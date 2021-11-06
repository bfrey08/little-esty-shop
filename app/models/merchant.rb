class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items

  def top_5
    items.top_5_by_revenue
  end

  def self.enabled?
    where(status: true)
  end

  def self.disabled?
    where(status: false)
  end
end
