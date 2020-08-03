module Coupons
  # Coupons::CouponNames
  class CouponNames
    def call
      [''].concat(Coupon.pluck(:name))
    end
  end
end
