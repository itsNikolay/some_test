class OrdersController < ApplicationController
  before_action :find_order!, only: %i[show cancel]

  def index
    orders = Orders::OrderList.new(permitted_params).call
    @paged_orders = Paginations::SimplePagination.new(orders, params[:page])
  end

  def show; end

  def cancel
    Orders::CancelOrder.new(@order).call
    flash[:notice] = "Order #{@order.number} has cancelled"
    redirect_to orders_path
  end

  private

  def find_order!
    @order = Order.find_by!(number: params[:number])
  end

  def permitted_params
    params.permit(:number, :page)
  end
end
