FactoryBot.define do
  factory :user, class: Protosite::User do
    sequence(:email) { |n| "agent+#{n}@isis.com" }
    password { "password" }
    name { "Secret Agent" }
  end

  factory :page, class: Protosite::Page do
    initialize_with { Protosite::Page.build_from_data(attributes) }

    transient do
      sequence(:title) { |n| "Test Page #{n}" }
      slug { nil }
      sort { nil }
    end

    data do
      { "title" => title, "slug" => slug, "sort" => sort }
    end
  end
end
