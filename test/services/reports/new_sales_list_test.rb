require 'test_helper'

module Reports
  # Reports::NewSalesListTest
  class NewSalesListTest < ActiveSupport::TestCase
    test '#all' do
      payments = Reports::NewSalesList.new({}).call
      assert_equal payments, []
    end
  end
end
