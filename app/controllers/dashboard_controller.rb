class DashboardController < ApplicationController
  def show
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items
  end
end
