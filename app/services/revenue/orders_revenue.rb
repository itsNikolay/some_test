module Revenue
  # Revenue::OrdersRevenue
  class OrdersRevenue
    attr_reader :orders

    def initialize(orders)
      @orders = orders
    end

    def call
      orders.sum(&:total)
    end
  end
end
