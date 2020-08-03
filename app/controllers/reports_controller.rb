class ReportsController < ApplicationController
  def index
    @coupon_names = [''].concat(Coupon.pluck(:name))
    @coupons = Reports::CouponList.new(permitted_params).call
  end

  private

  def permitted_params
    params.permit(:name)
  end
end
