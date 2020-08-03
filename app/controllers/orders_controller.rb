class OrdersController < ApplicationController
  before_action :find_order!, only: :show

  def index
    @orders = Orders::OrderList.new(permitted_params).call
  end

  def show
  end

  def cancel
    find_order!
    @order.update!(state: Order::CANCELED)
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
