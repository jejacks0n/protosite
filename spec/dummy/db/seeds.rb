Protosite::User.create!(name: "Admin User", email: "admin@legworkstudio.com", password: "password", admin: true)
Protosite::Page.create_from_data!(data: { title: "Home Page" })
