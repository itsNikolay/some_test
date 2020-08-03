require 'test_helper'

module Orders
  # Services::Orders::CancelOrderTest
  class CancelOrderTest < ActiveSupport::TestCase
    test '#call' do
      order = orders(:arrived_order)
      Orders::CancelOrder.new(order).call
      assert_equal order.state, Order::CANCELED
      assert_equal order.payments.pluck(:state).uniq, [Payment::REFUNDED]
    end
  end
end
