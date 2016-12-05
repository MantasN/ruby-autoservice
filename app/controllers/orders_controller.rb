# Controller to manage orders resource
class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to @order
    else
      render 'new'
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def index
    @orders = Order.order('date').all
  end

  def edit
    @order = Order.find(params[:id])
    return unless @order.state != 'pending'
    flash[:error] = 'Only pending order can be edited'
    redirect_to orders_path
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      redirect_to @order
    else
      render 'edit'
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to orders_path
  end

  private

  def order_params
    params
      .require(:order)
      .permit(:date, :state, detail_attributes: [:id, :reason, :car, :owner])
  end
end
