$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "protosite/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "protosite"
  s.version     = Protosite::VERSION
  s.authors     = ["Legwork Studio"]
  s.email       = ["devs@legworkstudio.com"]
  s.homepage    = "https://github.com/legworkstudio/protosite"
  s.summary     = "Protosite: An elegant and customizable vue based CMA"
  s.description = ["Protosite: An elegant and customizable vue based CMA"].join(" ")
  s.license     = "MIT"

  s.files       = Dir["{app,lib}/**/*"] + ["MIT-LICENSE", "README.md"]

  s.add_dependency "railties", [">= 3.2.5", "< 6"]
  s.add_dependency "graphql", ">= 1.8.5"
  s.add_dependency "graphql-errors", ">= 0.2.0"
  s.add_dependency "warden", ">= 1.2.7"
  s.add_dependency "bcrypt", ">= 3.1.12"
end
