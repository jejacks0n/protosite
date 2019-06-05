require "spec_helper"

describe "Editing pages", type: :feature do
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
    ])
  end

  it "allows me to update the home page properties"
  it "retains versions of the content when I change it"
  it "allows me to move pages from one parent to another"
end
