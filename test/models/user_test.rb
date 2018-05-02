require './test/test_helper'

set :environment, :test

class UserTest < Test::Unit::TestCase
  include Rack::Test::Methods

  test :should_generate_uuid do
    user = User.create(arguments)
    assert user.uuid.present?
  end

  test :should_not_generate_uuid do
    user = User.create(arguments.merge(uuid: '123'))
    assert_equal '123', user.uuid
  end

  test :should_generate_name do
    user = User.create(arguments)
    assert_equal 'some', user.sortable_name
  end

  test :should_not_generate_name do
    user = User.create(arguments.merge(sortable_name: '123'))
    assert_equal '123', user.sortable_name
  end

  private

  def arguments
    { name: 'Some Name', workflow_state: :registered }
  end
end
