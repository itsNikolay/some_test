class ReportsController < ApplicationController
  def index
    @coupon_names = Coupons::CouponNames.new.call
    @coupons = Reports::CouponList.new(permitted_params).call

    payments = Payments::PaymentsList.new(permitted_params).call
    @products = Reports::NewSalesList.new(payments, permitted_params).call
  end

  private

  def permitted_params
    params.permit(:name, :completed_at_start, :completed_at_end)
  end
end
