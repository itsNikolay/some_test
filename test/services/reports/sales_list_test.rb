require 'test_helper'

module Reports
  # Reports::SalesListTest
  class SalesListTest < ActiveSupport::TestCase
    test '#all' do
      payments = Reports::SalesList.new(Payment.all).call
      assert_equal payments, []
    end
  end
end
