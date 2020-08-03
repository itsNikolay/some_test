module Reports
  # Reports::SalesList
  class SalesList
    attr_reader :payments

    def initialize(payments, _params = {})
      @payments = payments
    end

    def call
      Product
        .where(order_items: { state: OrderItem::SOLD })
        .joins(order_items: [:product, order: :payments])
        .where(order_items: { orders: { payments: payments.select(:id) } })
    end
  end
end
