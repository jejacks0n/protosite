require "spec_helper"

describe "Authentication", type: :feature do
  before do
    Protosite::Page.build_pages([
      title: "Home Page", slug: ""
    ])
  end

  let(:admin) { create(:user, admin: true) }

  it "renders the controls and toolbars if I'm an admin" do
    login_as admin
    visit "/"

    expect(page).to have_content "Protosite Demo"
    expect(page).to have_content "Home Page"
    expect(page).to have_content "[global interface]"
    expect(page).to have_content "[toolbar]"
  end

  it "allows me to sign out" do
    login_as admin
    visit "/"

    expect(page).to have_content "Protosite Demo"
    expect(page).to have_content "[global interface]"

    click_link("sign out")

    expect(page).to_not have_content "[global interface]"
  end
end
