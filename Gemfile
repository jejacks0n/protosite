source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rails", ">= 5.2.1"

gemspec

group :development, :test do
  gem "rubocop", require: false
  gem "rubocop-rails_config"

  # tests / dummy app
  gem "puma", "~> 3.11"
  gem "sqlite3"
  gem "slim-rails"
  gem "sassc-rails"
  gem "webpacker"
  gem "uglifier"
  gem "foreman", require: false

  gem "rspec-rails"
end
