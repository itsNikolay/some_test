require 'test_helper'

module Orders
  class OrderListTest < ActiveSupport::TestCase
    test 'all' do
      order_ids = Orders::OrderList.new({}).call.map(&:id)
      assert_equal order_ids, Order.all.pluck(:id)
    end

    test 'by_number' do
      order = orders(:arrived_order)

      orders = Orders::OrderList.new(number: 'wrong').call
      assert_equal orders.map(&:id), []

      orders = Orders::OrderList.new(number: order.number).call
      assert_equal orders.map(&:id), [order.id]
    end
  end
end
