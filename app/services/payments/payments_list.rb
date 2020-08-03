module Payments
  # Payments::PaymentsList
  class PaymentsList
    attr_reader :payments, :completed_at_end, :completed_at_start

    def initialize(params = {})
      @completed_at_start = params[:completed_at_start]
      @completed_at_end = params[:completed_at_end]
    end

    def call
      initialize_payments
      by_completed_at_start
      by_completed_at_end
      @payments
    end

    private

    def initialize_payments
      @payments = Payment.distinct.completed
    end

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
