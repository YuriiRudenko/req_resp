class User < ActiveRecord::Base
  require 'securerandom'

  enum workflow_state: %i[registered banned]

  default_scope -> { order(sortable_name: :desc) }

  has_many :account_users
  has_many :accounts, through: :account_users

  before_validation :generate_uuid,        if: ->(object) { object.uuid.blank? }
  before_validation :assign_sortable_name, if: ->(object) { object.sortable_name.blank? }

  validates :uuid, :name, :sortable_name, :workflow_state, presence: true

  private

  def generate_uuid
    self.uuid = SecureRandom.hex
    generate_uuid if User.exists?(uuid: uuid)
  end

  def assign_sortable_name
    self.sortable_name = name.split.first.downcase
  end
end
