require "spec_helper"

describe "Authentication", type: :feature do
  before do
    Protosite::Page.build_pages([
      title: "Home Page",
      slug: "",
      components: [
        {
          type: "hero",
          title: "Hero Component",
          text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean at auctor tortor.",
          "link.url": "http://cnn.com",
          "link.text": "CNN.com",
          style: "default",
        }
      ],
    ])
  end

  let(:admin) { create(:user, admin: true) }

  it "renders the controls and toolbars if I'm an admin" do
    login_as admin
    visit "/"

    expect(page).to have_content "Protosite Demo"
    expect(page).to have_content "Home Page"
    expect(page).to have_content "Hero Component"
    expect(page).to have_content "[global toolbar]"
    expect(page).to have_content "[page toolbar]"
    expect(page).to have_content "[component toolbar]"
  end

  it "allows me to sign out" do
    login_as admin
    visit "/"

    expect(page).to have_content "Protosite Demo"
    expect(page).to have_content "[global toolbar]"

    click_link("sign out")

    expect(page).to_not have_content "[global toolbar]"
  end
end
