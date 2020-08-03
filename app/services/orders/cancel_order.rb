module Orders
  # Orders::CancelOrder
  class CancelOrder
    attr_reader :order

    def initialize(order)
      @order = order
    end

    def call
      ActiveRecord::Base.transaction do
        @order.update!(state: Order::CANCELED)
        refund_payments
      end
    end

    private

    def refund_payments
      order.payments.each do |payment|
        payment.update!(state: Payment::REFUNDED)
      end
    end
  end
end
