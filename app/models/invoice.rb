class Invoice < ApplicationRecord
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  belongs_to :customer

  enum status: [:cancelled, :completed, 'in progress']

  def successful_transactions
    transactions.success
  end

  def top_selling_by_date
    joins(invoices: :invoice_items).select("invoices.created_at AS date, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue_by_day").group(:date).order(:revenue).first.date.strftime('%A, %B %d, %Y')
  end

  def self.ordered_incomplete_invoices
    incomplete_invoices_ids = InvoiceItem.incomplete_invoices
    Invoice.where(id: incomplete_invoices_ids).order(created_at: :asc).pluck(:id, :created_at)
  end

  # def self.discounted_revenue_by_merch
  #   Invoice.joins(invoice_items: [item: [merchant: [merchant_discounts: :bulk_discount]]]).select('invoice_items.*').having('invoice_items.quantity < bulk_discounts.threshold').group('invoices.id, invoice_items.id, bulk_discounts.id').select('SUM(invoice_items.quantity * invoice_items.unit_price) as IR').group('invoices.id')
  #
  # end
  def invoice_revenue
    InvoiceItem.group(:invoice_id).where(invoice_id: id).sum('quantity * unit_price').values.pop
  end

  def discounted_revenue(merchant_id)
    #is a merchant unique to an invoice?
    #If there is a discount for 30% on 10 items and a discount for 20% for 5 items -> does this method correctly take the 30% off the 10+ and 20% off the 5-9 items?
    #What about invoice status / transaction status / invoice item status?
    #can refactor to combine sql1 and sql2 using (AR 'only' method). Ask how to refactor to not include ANY RUBY (addition -- SQL case statement?)
    sql1 = (InvoiceItem.joins(:invoice, item: [merchant: [merchant_discounts: :bulk_discount]])
    .select('DISTINCT ON(invoice_items.id) invoice_items.*, SUM(invoice_items.quantity * invoice_items.unit_price * (1 - bulk_discounts.percentage)) AS ir')
    .having('invoice_items.quantity >= bulk_discounts.threshold')
    .having('bulk_discounts.percentage = MAX(bulk_discounts.percentage)')
    .where(invoices: {id: id})
    .where("merchants.id = #{merchant_id}")
    .group(' invoice_items.id, bulk_discounts.id')).to_sql


    sql2 = (InvoiceItem.joins(:invoice, item: [merchant: :bulk_discounts])
    .select('DISTINCT ON(invoice_items.id) invoice_items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS uir, bulk_discounts.threshold')
    .having('invoice_items.quantity < MIN(bulk_discounts.threshold)')
    .where(invoices: {id: id})
    .where("merchants.id = #{merchant_id}")
    .group('invoice_items.id, bulk_discounts.id')).to_sql
     (InvoiceItem.select('Sum(ir) as total_ir').from("(#{sql1}) as total_irs").take.total_ir + InvoiceItem.select('Sum(uir) as total2_ir').from("(#{sql2}) as total2_irs").take.total2_ir).round

  end
end
