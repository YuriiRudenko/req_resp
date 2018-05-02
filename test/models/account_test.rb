require './test/test_helper'

set :environment, :test

class AccountTest < Test::Unit::TestCase
  include Rack::Test::Methods

  test :should_add_id_to_redis do
    account_id = Account.create.id
    assert REDIS.exists(account_id)
  end

  test :should_remove_id_to_redis do
    account = Account.create
    account.destroy
    assert !REDIS.exists(account.id)
  end

  test :should_contains_ids_of_exist_accounts do
    assert_equal Account.pluck(:id).sort, Account.ids.sort
  end
end
