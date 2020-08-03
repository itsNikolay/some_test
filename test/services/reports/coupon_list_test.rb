require 'test_helper'
require 'faker'

module Reports
  class CouponListTest < ActiveSupport::TestCase
    test 'all' do
      user = create_user
      address = create_address(user)
      order = create_order(user, address)
      coupon = create_coupon(order)

      coupons = Reports::CouponList.new({}).call
      assert_equal coupons.map(&:id), [coupon.id]
    end

    test 'by_name' do
      user = create_user
      address = create_address(user)
      order = create_order(user, address)
      coupon = create_coupon(order)

      coupons = Reports::CouponList.new({ name: coupon.name }).call
      assert_equal coupons.map(&:id), [coupon.id]

      coupons = Reports::CouponList.new({ name: 'wrong' }).call
      assert_equal coupons.map(&:id), []
    end

    private

    def create_user
      User.create! \
        name: 'John',
        email: Faker::Internet.safe_email(name: name)
    end

    def create_address(user)
      Address.create! \
        user: user,
        address1: Faker::Address.street_address,
        address2: ([true, false].sample ? Faker::Address.secondary_address : nil),
        city: Faker::Address.city,
        state: Faker::Address.state_abbr,
        zipcode: Faker::Address.zip_code.first(5)
    end

    def create_order(user, address)
      Order.create! \
        number: rand(1000),
        user: user,
        state: Order::CANCELED,
        total: rand(10),
        address: address
    end

    def create_coupon(order)
      coupon = Coupon.create! \
        name: Faker::Commerce.promotion_code(digits: 2),
        amount: Faker::Commerce.price

      OrderItem.create \
        order: order,
        source: coupon,
        quantity: 1,
        price: -coupon.amount

      coupon
    end
  end
end
