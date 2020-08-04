module Orders
  # Orders::OrderList
  class OrderList
    attr_reader :number, :page, :orders
    PER_PAGE = 10

    def initialize(params)
      @number = params[:number]
      @page = params[:page]
    end

    def call
      @orders = Order.all
      by_number
      @orders.includes(:user)
    end

    private

    def by_number
      return if number.blank?

      @orders = orders.by_like_number(number)
    end
  end
end
