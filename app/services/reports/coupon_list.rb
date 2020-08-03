module Reports
  # Reports::CouponList
  class CouponList
    attr_reader :coupons, :coupon, :name

    def initialize(params = {})
      @coupon = params[:coupon]
      @name = params[:name]
    end

    def call
      initialize_coupons
      select_by_name
      @coupons.includes(order_items: { order: :user })
    end

    private

    def initialize_coupons
      @coupons =
        Coupon
        .distinct
        .left_joins(order_items: { order: :user })
    end

    def select_by_name
      return if name.blank?

      @coupons = coupons.where(name: name)
    end
  end
end
