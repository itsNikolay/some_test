module Reports
  # Reports::NewSalesList
  class NewSalesList
    attr_reader :payments

    def initialize(payments, _params = {})
      @payments = payments
    end

    def call
      Product
        .joins(:order_items)
        .where(order_items: { state: OrderItem::SOLD })
        .where(order_items: { order_id: payments.select('payments.order_id') })
        .group('1', '2')
        .pluck('products.id', 'products.name', 'SUM(order_items.price)', 'COUNT(order_items.quantity)')
    end
  end
end
