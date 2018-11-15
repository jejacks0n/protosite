# This migration comes from protosite (originally 20181020102030)
class CreateProtositeTables < ActiveRecord::Migration[5.2]
  def change
    create_table :protosite_pages do |t|
      t.string :slug, null: false
      t.string :title, null: false
      t.json :data, default: {}
      t.json :versions, default: []

      t.timestamps null: false
    end

    create_table :protosite_users do |t|
      t.string :name, null: false
      t.string :email, null: false

      t.string :authentication_token, null: false
      t.string :password_digest

      t.json :permissions, default: {}, null: false

      t.timestamps null: false
    end

    add_index :protosite_pages, :slug

    add_index :protosite_users, :email, unique: true
    add_index :protosite_users, :authentication_token, unique: true
  end
end
