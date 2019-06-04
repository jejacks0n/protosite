require "spec_helper"

describe "Rendering pages", type: :feature do
  before do
    Protosite::Page.build_pages([
      title: "Home", slug: "",
      components: [
        {
          type: "hero",
          title: "Hero component",
          text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean at auctor tortor.",
          "link.url": "http://cnn.com",
          "link.text": "CNN.com",
          style: "default",
        }
      ],
      children: [
        title: "About us",
      ]
    ])
  end

  it "shows page details and components" do
    visit "/"

    expect(page).to have_content "Protosite Demo"
    expect(page).to_not have_content "[global interface]"

    within("nav") do
      expect(page).to have_content "Home"
      expect(page).to have_content "About us"
    end

    within("section.content") do
      expect(page).to have_content "Home"
      expect(page).to have_content "Hero component"
    end
  end

  it "allows navigating to other pages" do
    visit "/"

    click_link("About us")

    within("section.content") do
      expect(page).to have_content "About us"
      expect(page).to_not have_content "Home"
    end
  end

  it "renders the controls and toolbars if I'm an admin" do
    login_as create(:user, admin: true)
    visit "/"

    expect(page).to have_content "Protosite Demo"
    expect(page).to have_content "[global interface]"
    expect(page).to have_content "[toolbar]"

    within("section.content") do
      expect(page).to have_content "Hero component"
      expect(page).to have_content "[controls]"
    end
  end

  it "allows me to update the home page properties"
  it "retains versions of the content when I change it"
  it "allows me to move pages from one parent to another"
end
