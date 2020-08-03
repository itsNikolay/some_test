require 'test_helper'
require 'faker'

module Orders
  class OrderListTest < ActiveSupport::TestCase
    test 'all' do
      user = create_user
      address = create_address(user)
      order = create_order(user, address)

      order_ids = Orders::OrderList.new({}).call.map(&:id)
      assert_equal order_ids, [order.id]
    end

    test 'by_number' do
      user = create_user
      address = create_address(user)
      order = create_order(user, address)

      orders = Orders::OrderList.new(number: 'wrong').call
      assert_equal orders.map(&:id), []

      orders = Orders::OrderList.new(number: order.number).call
      assert_equal orders.map(&:id), [order.id]
    end

    private

    def create_user
      User.create! \
        name: 'John',
        email: Faker::Internet.safe_email(name: name)
    end

    def create_address(user)
      Address.create! \
        user: user,
        address1: Faker::Address.street_address,
        address2: ([true, false].sample ? Faker::Address.secondary_address : nil),
        city: Faker::Address.city,
        state: Faker::Address.state_abbr,
        zipcode: Faker::Address.zip_code.first(5)
    end

    def create_order(user, address)
      Order.create! \
        number: rand(1000),
        user: user,
        state: Order::CANCELED,
        total: rand(10),
        address: address
    end
  end
end
