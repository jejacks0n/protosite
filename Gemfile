source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rails", ">= 5.2.1"

gemspec

group :development, :test do
  gem "rubocop", "0.60", require: false
  gem "rubocop-rails_config"

  # dummy app
  gem "puma", "~> 5.3"
  gem "sqlite3"
  gem "slim-rails"
  gem "sassc-rails"
  gem "webpacker", "~> 4.0"
  gem "uglifier"
  gem "foreman", require: false

  # tests
  gem "rspec-rails"
  gem "selenium-webdriver"
  gem "chromedriver-helper"
  gem "capybara"
  gem "factory_bot_rails"
  gem "shoulda-matchers"
  gem "rspec-graphql_matchers", github: "jejacks0n/rspec-graphql_matchers"
  gem "simplecov", require: false
end
