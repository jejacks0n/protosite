require "spec_helper"

describe Protosite::Page, type: :model do
  subject { build(:page) }

  it { is_expected.to belong_to(:parent) }
  it { is_expected.to have_many(:children).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:slug).with_message("can't be blank -- provide a title or slug in data") }
  it { is_expected.to validate_uniqueness_of(:slug).scoped_to(:parent_id) }

  describe "scopes" do
    describe ".roots" do
      it "limits to the root pages" do
        expect(described_class.roots.to_sql).to match <<-SQL.strip_heredoc.gsub("\n", " ").strip
          WHERE "protosite_pages"."parent_id" IS NULL
          ORDER BY "protosite_pages"."sort" ASC, "protosite_pages"."created_at" DESC
        SQL
      end
    end
  end

  describe "building from data" do
    let(:parent) { create(:page) }

    it "allows pulling some attributes from data" do
      subject = build(:page, data: { "parent_id" => parent.id, "sort" => 666, "slug" => "custom-slug" })

      expect(subject.parent).to eq parent
      expect(subject.slug).to eq "custom-slug"
      expect(subject.sort).to eq 666
    end

    it "sets the slug from the title" do
      subject = build(:page, data: { "title" => "Weird & long title" })

      expect(subject.slug).to eq "weird-long-title"
    end
  end

  describe "defaulting the sort" do
    it "sets it to the number of siblings if none was provided" do
      expect(subject.sort).to eq nil

      create(:page)
      create(:page)

      subject.save!
      expect(subject.sort).to eq 2
    end
  end

  describe "#add_version!" do
    it "adds a new version at the front of the versions array" do
      subject.add_version!(foo: "bar")
      expect(subject.versions).to eq [{ "foo" => "bar" }]

      subject.add_version!(bar: "baz")
      expect(subject.versions).to eq [{ "bar" => "baz" }, { "foo" => "bar" }]
    end
  end

  describe "#publish!" do
    it "sets the data to the latest version and sets its published state to true" do
      subject.add_version!(foo: "bar")
      subject.add_version!(bar: "baz", slug: "custom-slug")

      subject.publish!
      expect(subject.data).to eq "bar" => "baz", "slug" => "custom-slug"
      expect(subject.published?).to be_truthy
    end
  end
end
