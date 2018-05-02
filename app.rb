require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/cache'
require 'sinatra/param'
require './config/redis'
require './config/hash'

Dir['./app/**/*.rb'].each { |file| require file }

set :database,     YAML.safe_load(File.open('config/database.yml'))[ENV['RACK_ENV']]
set :content_type, :json

helpers Helpers

before do
  content_type :json
end

get '/api/v1/instructure/accounts/:account_id/users', provides: :json do
  validate_account
  collect_users
end
