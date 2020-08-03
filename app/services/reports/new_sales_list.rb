module Reports
  # Reports::NewSalesList
  class NewSalesList
    attr_reader :payments, :completed_at_end, :completed_at_start

    def initialize(params = {})
      @completed_at_start = params[:completed_at_start]
      @completed_at_end = params[:completed_at_end]
    end

    def call
      @payments = Payment
                  .distinct
                  .completed
                  .joins(order: [order_items: :product])

      by_completed_at_start
      by_completed_at_end

      @payments
        .group('products.id', 'products.name')
        .pluck('products.id', 'products.name', 'SUM(payments.amount)', 'COUNT(*)')
    end

    private

    def by_completed_at_start
      return if completed_at_start.blank?

      @payments = payments.by_completed_at_gteq(completed_at_start)
    end

    def by_completed_at_end
      return if completed_at_end.blank?

      @payments = payments.by_completed_at_lt(completed_at_end)
    end
  end
end
