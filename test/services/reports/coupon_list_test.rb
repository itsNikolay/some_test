require 'test_helper'

module Reports
  class CouponListTest < ActiveSupport::TestCase
    test '#all' do
      coupons = Reports::CouponList.new({}).call
      assert_equal coupons.map(&:id), Coupon.all.pluck(:id)
    end

    test '#by_name' do
      coupon = coupons(:one)

      coupons = Reports::CouponList.new({ name: coupon.name }).call
      assert_equal coupons.map(&:id), [coupon.id]

      coupons = Reports::CouponList.new({ name: 'wrong' }).call
      assert_equal coupons.map(&:id), []
    end
  end
end
