module Reports
  # Reports::ProductSalesList
  class ProductSalesList
    attr_reader :products, :completed_at_start, :completed_at_end

    def initialize(params = {})
      @completed_at_start = params[:completed_at_start]
      @completed_at_end = params[:completed_at_end]
    end

    def call
      @products = get_products.map do |product|
        [product, amounts_by_product_id[product.id]]
      end
    end

    private

    def get_products
      Product.distinct.all
        .joins(order_items: :order)
        .where(order_items: { orders: { id: order_ids } })
        .order(:id)
    end

    def amounts_by_product_id
      @amounts_by_product_id ||= 
        product_orders.each_with_object({}) do |pr, obj|
          product_id = pr[0]
          order_id = pr[1]
          amount = amounts_by_order_id[order_id]
          obj[product_id] = (obj[product_id] || 0) + amount
        end
    end

    def product_orders
      get_products.pluck(:id, 'orders.id')
    end

    def order_ids
      amounts_by_order_id.keys
    end

    def amounts_by_order_id
      @amounts_by_order_id ||=
        amounts.each_with_object({}) do |am, obj|
          order_id = am[0]
          amount = am[1]
          obj[order_id] = (obj[order_id] || 0) + amount
        end
    end

    def amounts
      payments.pluck(:order_id, :amount)
    end

    def payments
      Reports::SalesList
        .new(completed_at_start: completed_at_start, completed_at_end: completed_at_end)
        .call
    end
  end
end
