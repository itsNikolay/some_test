require 'test_helper'
require 'faker'

module Reports
  # Reports::ProductSalesListTest
  class ProductSalesListTest < ActiveSupport::TestCase
    test 'all' do
      user = create_user
      address = create_address(user)
      order = create_order(user, address)
      product = create_product
      order_item = create_order_item(order, product, 2, 'sold')
      payment = create_payment(order)

      products = Reports::ProductSalesList.new({}).call
      assert_equal products.map(&:id), [product.id]
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

    def create_payment(order)
      Payment.create! \
        order: order,
        amount: order.order_items.sum(&:price),
        completed_at: order.building_at,
        payment_type: Payment::PAYMENT_TYPES.sample,
        state: Payment::COMPLETED
    end

    def create_product
      sku = rand(1000)
      msrp = (20..60).to_a.sample
      Product.create! \
        msrp: msrp,
        cost: (msrp / 3),
        name: Faker::Commerce.product_name,
        sku: "#{"%03d" % sku}-#{("A"..."Z").to_a.sample}"
    end

    def create_order_item(order, product, quantity, state)
      OrderItem.new \
        order: order,
        source: product,
        quantity: quantity,
        price: (quantity * product.msrp).round(2),
        state: state
    end
  end
end
