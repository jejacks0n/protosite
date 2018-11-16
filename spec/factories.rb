FactoryBot.define do
  factory :user, class: Protosite::User do
    sequence(:email) { |n| "agent+#{n}@isis.com" }
    password { "password" }
    name { "Secret Agent" }
  end

  factory :page, class: Protosite::Page do
    initialize_with { Protosite::Page.create_from_data!(attributes) }
    parent_id { nil }

    transient do
      sequence(:title) { |n| "Test Page #{n}" }
      slug { nil }
    end

    data do
      {
        "title" => title,
        "slug" => slug
      }
    end
  end
end
