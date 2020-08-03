class ReportsController < ApplicationController
  def index
    @coupon_names = [''].concat(Coupon.pluck(:name))
    @coupons = Reports::CouponList.new(permitted_params).call
    # @products = Reports::ProductSalesList.new(permitted_params).call
    @products = Reports::NewSalesList.new(permitted_params).call
  end

  private

  def permitted_params
    params.permit(:name, :completed_at_start, :completed_at_end)
  end
end
