require "spec_helper"

describe "Rendering pages", type: :feature do
  before do
    Protosite::Page.build_pages([
      title: "Home", slug: "",
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
      children: [
        title: "About Us",
      ]
    ])
  end

  it "shows page details and components" do
    visit "/"

    expect(page).to have_content "Protosite Demo"
    expect(page).to_not have_content "[global toolbar]"

    within("nav") do
      expect(page).to have_content "Home"
      expect(page).to have_content "About Us"
    end

    within("section.content") do
      expect(page).to have_content "Home"
      expect(page).to have_content "Hero Component"
    end
  end

  it "allows navigating to other pages" do
    visit "/"

    click_link("About Us")

    within("section.content") do
      expect(page).to have_content "About Us"
      expect(page).to_not have_content "Home"
    end
  end
end
