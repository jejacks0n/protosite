Protosite::User.create!(name: "Admin User", email: "admin@legworkstudio.com", password: "password", admin: true)

Protosite::Page.build_pages([
  {
    id: "error_404", # we give this a specific ID so we can always reference it
    title: "404",
  },
  {
    title: "Home Page",
    slug: "", # we can leave this blank for the home page
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
