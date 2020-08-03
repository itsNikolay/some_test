module Revenue
  # Revenue::PaymentsRevenue
  class PaymentsRevenue
    attr_reader :payments, :completed_at_start, :completed_at_end

    def initialize(params ={})
      @product = params[:product]
      @completed_at_start = params[:completed_at_start]
      @completed_at_end = params[:completed_at_end]
    end

    def call
      Payment
        .distinct
        .completed
        .joins(order_items: :order)
        .where(id: payments).sum(:amount)
    end
  end
end
