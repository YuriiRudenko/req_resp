class Account < ActiveRecord::Base
  has_many :account_users
  has_many :users, through: :account_users

  after_save    :cache_to_redis
  after_destroy :remove_from_redis

  private

  def cache_to_redis
    REDIS.set(id, true)
  end

  def remove_from_redis
    REDIS.del(id)
  end

  class << self
    def ids
      data = REDIS.keys
      return data if data.present?
      pluck(:id).each { |id| REDIS.set(id, true) }
    end
  end
end
