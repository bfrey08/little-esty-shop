class CreateMerchantDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :merchant_discounts do |t|
      t.string :name
      t.references :merchant, foreign_key: true
      t.references :bulk_discount, foreign_key: true
    end
  end
end
