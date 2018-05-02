require './app'
require 'test/unit'
require 'rack/test'
require 'database_cleaner'
require 'active_record/fixtures'

ActiveRecord::Base.establish_connection(:test)

class Test::Unit::TestCase
  def teardown
    DatabaseCleaner.clean
    REDIS.flushdb
    fixtures_dir = './test/fixtures'
    fixture_files = Dir["#{fixtures_dir}/**/*.yml"].map { |f| f[(fixtures_dir.size + 1)..-5] }
    ActiveRecord::FixtureSet.create_fixtures(fixtures_dir, fixture_files)
  end
end
