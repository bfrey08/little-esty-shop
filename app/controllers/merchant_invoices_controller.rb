class MerchantInvoicesController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices
    # @invoice = Invoice.find(params[:invoice_id])
  end
end