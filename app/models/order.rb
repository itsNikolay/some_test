class Order < ApplicationRecord
  BUILDING = 'building'.freeze
  ARRIVED = 'arrived'.freeze
  CANCELED = 'canceled'.freeze
  STATES = [BUILDING, ARRIVED, CANCELED].freeze

  validates_presence_of :user_id, :state

  validates   :total,
              presence: true,
              format: {
                with: /\A-?\d+\.?\d{0,2}\z/,
                message: 'only accepts 2 decimal places.'
              }

  belongs_to :user
  belongs_to :address

  has_many :order_items
  has_many :payments

  scope :by_number, ->(number) { where(number: number) }
  scope :by_state, ->(state) { where(state: state) }
  scope :by_like_number, lambda { |number|
    sanitized_name = ActiveRecord::Base.sanitize_sql_like(number)
    where('orders.number LIKE ?', "%#{sanitized_name}%")
  }

  def to_param
    number
  end
end
