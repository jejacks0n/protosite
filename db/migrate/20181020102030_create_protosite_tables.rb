class CreateProtositeTables < ActiveRecord::Migration[5.2]
  def change
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
  end
end
