source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gem 'vtasks', require: false

gem 'rake', require: false
gem 'dotenv', require: false

group :development do
  gem 'github_changelog_generator', require: false
  gem 'travis', require: false
end
