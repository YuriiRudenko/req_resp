require './test/test_helper'

set :environment, :test

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  USERS_DATA = YAML.safe_load(File.open('./test/fixtures/users.yml')).symbolize_keys.freeze
  ACCOUNTS_DATA = YAML.safe_load(File.open('./test/fixtures/accounts.yml')).symbolize_keys.freeze
  PATH = '/api/v1/instructure/accounts'.freeze

  def app
    Sinatra::Application
  end

  def account_url(key)
    "#{PATH}/#{ACCOUNTS_DATA[key]['id']}/users"
  end

  test :should_return_error_for_non_exists_account do
    get "#{PATH}/999/users"
    assert !last_response.ok?
    assert_equal 404, last_response.status
    assert_equal 'Account not found', response['error']
  end

  test :should_return_an_array_for_account do
    get account_url(:first)
    assert last_response.ok?
    assert_equal 200, last_response.status
    assert_equal Array, response.class
  end

  test :should_return_one_user_for_first_account do
    get account_url(:first)
    assert last_response.ok?
    assert_equal 200, last_response.status
    assert_equal 1, response.size

    check_user(:anthony, first_object)
  end

  test :should_return_three_users_for_second_account do
    get account_url(:second)
    assert last_response.ok?
    assert_equal 200, last_response.status
    assert_equal 3, response.size

    check_user(:anthony, first_object)
    check_user(:bruce, second_object)
    check_user(:steve, third_object)
  end

  test :should_return_empty_list_for_third_account do
    get account_url(:third)
    assert last_response.ok?
    assert_equal 200, last_response.status
    assert response.blank?
  end

  test :should_return_error_for_non_integer_account_id do
    get "#{PATH}/abc123/users"
    assert !last_response.ok?
    assert_equal 400, last_response.status
    assert_equal 'Incorrect id', response['error']
  end

  private

  def response
    JSON.parse(last_response.body)
  end

  def first_object
    response.first.symbolize_keys
  end

  def second_object
    response.second.symbolize_keys
  end

  def third_object
    response.third.symbolize_keys
  end

  def check_user(fixture_key, user)
    USERS_DATA[fixture_key].each do |attribute, value|
      assert_equal attribute_value(attribute, value), user[attribute.to_sym]
    end
  end

  def attribute_value(attribute, value)
    attribute == 'workflow_state' ? User.workflow_states.invert[value] : value
  end
end
