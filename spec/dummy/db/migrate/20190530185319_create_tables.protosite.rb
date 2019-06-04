# This migration comes from protosite (originally 20181020102030)
class CreateTables < ActiveRecord::Migration[5.2]
  def up
    create_table :protosite_users do |t|
      t.string :name, null: false
      t.string :email, null: false

      t.string :authentication_token, null: false
      t.string :password_digest

      t.json :permissions, default: {}, null: false
      t.boolean :admin, default: false, null: false

      t.timestamps null: false
    end

    add_index :protosite_users, :email, unique: true
    add_index :protosite_users, :authentication_token, unique: true

    create_table :protosite_pages, id: :string do |t|
      t.string :parent_id
      t.string :slug
      t.integer :sort
      t.boolean :published, null: false, default: false
      t.json :data, default: {}, null: false
      t.json :versions, default: [], null: false

      t.timestamps null: false
    end

    add_index :protosite_pages, :slug

    create_user_records
    create_page_records
  end

  def down
    drop_table :protosite_users
    drop_table :protosite_pages
  end

  def create_user_records
    Protosite::User.create!(name: "Admin User", email: "admin@protosite", password: "password", admin: true)
  end

  def create_page_records
    Protosite::Page.build_pages([
      {
        id: "error_404", # we give this a specific ID so we can always reference it
        title: "404",
      },
      {
        title: "Home Page",
        slug: "", # we can leave this blank for the home page
        type: "home-page", # we want home to use a special template
        color: "#eee", # our custom home template can handle color!
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
          {
            title: "Work",
          },
          {
            title: "About",
            slug: "about-us", # we want a custom slug for the about page
          }
        ]
      },
    ])
  end
end
