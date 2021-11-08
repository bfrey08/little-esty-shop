class MerchantInvoicesController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices
  end

  def show
    @invoice = Invoice.find(params[:id])
    @invoice_items = InvoiceItem.find_by(invoice_id: @invoice.id)
    @item = Item.find(@invoice_items.item_id)
  end

  def update
    invoice = Invoice.find(params[:id])
    invoice.update(invoice_params)
    redirect_to "/merchants/#{merchant.id}/invoices/#{invoice.id}"
  end

  private
  def invoice_params
    params.require(:invoice).permit(:status)
  end
end