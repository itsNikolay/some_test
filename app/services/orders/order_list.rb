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
      by_page
      @orders.includes(:user)
    end

    private

    def by_number
      return if number.blank?

      @orders = orders.by_number(number)
    end

    def by_page
      return @orders = orders.by_page(0, PER_PAGE) if page.blank?

      @orders = orders.by_page(page.to_i, PER_PAGE)
    end
  end
end
