source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rails", ">= 5.2.1"

gemspec

group :development, :test do
  gem "rubocop", require: false
  gem "rubocop-rails_config"

  # tests / dummy app
  gem "graphiql-rails"
  gem "sqlite3"
  gem "rspec-rails"
end
