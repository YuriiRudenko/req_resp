source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'pg'
gem 'redis'
gem 'sinatra'
gem 'sinatra-activerecord'

group :development do
  gem 'rubocop'
end

group :test do
  gem 'database_cleaner'
end
