class ReportsController < ApplicationController
  def index
    @coupon_names = Coupons::CouponNames.new.call
    @coupons = Reports::CouponList.new(permitted_params).call

    @products = Reports::PaginatedSalesList.new(permitted_params).call
  end

  private

  def permitted_params
    params.permit(:page, :name, :completed_at_start, :completed_at_end)
  end
end
