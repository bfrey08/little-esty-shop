class MerchantDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_discounts = MerchantDiscount.where(merchant_id: params[:merchant_id])
  end

  def destroy
    @merchant_discount = MerchantDiscount.find(params[:id])
    MerchantDiscount.destroy(@merchant_discount.id)
    redirect_to "/merchants/#{@merchant_discount.merchant_id}/discounts"
  end
  def new
    @merchant = Merchant.find(params[:merchant_id])

  end
  def create
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.create!(percentage: params[:percentage], threshold: params[:threshold])
    @merchant.merchant_discounts.create!(name: params[:name], merchant_id: @merchant.id, bulk_discount_id: @bulk_discount.id)

    redirect_to "/merchants/#{@merchant.id}/discounts"
  end
  def show
    @merchant_discount = MerchantDiscount.find(params[:id])
  end
  def edit

    @merchant_discount = MerchantDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant_discount.bulk_discount
    if @merchant_discount.update(name: params[:name]) && @bulk_discount.update(threshold: params[:threshold], percentage: params[:percentage])
      flash[:notice] = "Successfully Updated Information"
      redirect_to "/merchants/#{@merchant.id}/discounts/#{@merchant_discount.id}"
    else
      flash[:alert] = "Error: #{error_message(@merchant_discount.errors)}"
      redirect_to "/merchants/#{@merchant.id}/discounts/#{@merchant_discount.id}/edit"
    end

  end
end


#Merchant Bulk Discounts Index

# As a merchant
# When I visit my merchant dashboard
# Then I see a link to view all my discounts
# When I click this link
# Then I am taken to my bulk discounts index page
# Where I see all of my bulk discounts including their
# percentage discount and quantity thresholds
# And each bulk discount listed includes a link to its show page
