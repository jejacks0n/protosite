begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

# Dummy App
APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load "rails/tasks/engine.rake"

# Gem tasks
begin
  Bundler::GemHelper.install_tasks
rescue RuntimeError
  Bundler::GemHelper.install_tasks name: "protosite"
end

# Rubocop
require "rubocop/rake_task"
RuboCop::RakeTask.new

# RSpec
load "rspec/rails/tasks/rspec.rake"

namespace :spec do
  desc "Run the unit code examples"
  RSpec::Core::RakeTask.new(:unit) do |t|
    file_list = FileList["spec/**/*_spec.rb"]
    %w[features].each do |exclude|
      file_list = file_list.exclude("spec/#{exclude}/**/*_spec.rb")
    end
    t.pattern = file_list
  end
end

# Define the default
Rake::Task["default"].prerequisites.clear
Rake::Task["default"].clear

task default: [:rubocop, "app:db:test:prepare", :spec]
