class OrdersController < ApplicationController
  before_action :ensure_authenticated
  before_action :set_order, only: [ :confirmation ]

  def confirmation
    @order = current_user.orders.last
    render partial: "orders/confirmation", locals: { order: @order }
  end

  private

  def ensure_authenticated
    redirect_to new_session_path, alert: "Please sign in to view your orders" unless authenticated?
  end

  def set_order
    @order = current_user.orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Order not found"
  end
end
