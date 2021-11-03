class AdminMerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    if merchant.update(merchant_params)
      flash[:notice] = "Successfully Updated Information"
      redirect_to "/admin/merchants/#{merchant.id}"
    else
      redirect_to "/admin/merchants/#{merchant.id}/edit"
      flash[:alert] = "Error: #{error_message(merchant.errors)}"
    end
  end

  private

    def merchant_params
      params.permit(:name, :updated_at)
    end
end
