module Reports
  # Reports::PaginatedSalesList
  class PaginatedSalesList
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def call
      paginated_products = Paginations::SimplePagination.new(products, params[:page])
      paginated_products.paged_records do |records|
        records
          .group('1', '2', '3')
          .pluck('products.id',
                 'products.name',
                 'order_items.price',
                 'COUNT(*)',
                 'order_items.quantity',
                 'SUM(order_items.price * order_items.quantity)')
      end
      paginated_products
    end

    private

    def payments
      Payments::PaymentsList.new(params).call
    end

    def products
      Reports::SalesList.new(payments, params).call
    end
  end
end
