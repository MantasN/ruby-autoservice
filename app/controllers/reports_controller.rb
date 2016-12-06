# Controller to manage reports resource
class ReportsController < ApplicationController
  def new
    @order = Order.find(params[:order_id])
    @report = Report.new
    return unless @order.state != 'ongoing'
    flash[:error] = 'Report can only be assigned to ongoing order'
    redirect_to @order
  end

  def create
    @order = Order.find(params[:order_id])

    if @order.state == 'ongoing'
      @report = Report.new(report_params)
      @report.order = @order
      if @report.save
        redirect_to @order
        return
      end
    end

    render 'new'
  end

  def destroy
    @order = Order.find(params[:order_id])
    @order.report.destroy
    redirect_to @order
  end

  def show
    @order = Order.find(params[:order_id])
    @report = @order.report
  end

  private

  def report_params
    params.require(:report).permit(:comment, :car_mileage)
  end
end
