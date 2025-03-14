require 'rails_helper'

RSpec.describe Merchant, type: :model do
  before :each do
    @merchant_1 = Merchant.create!(name: "Larry's Lucky Ladles")
    @merchant_2 = Merchant.create!(name: "Bob's Burgers")
    @merchant_3 = Merchant.create!({name: "Spatula City", status: false})
    @merchant_4 = Merchant.create!({name: "Pookah Pagoda", status: false})
    @merchant_5 = Merchant.create!(name: "A Fridge Too Far")
    @merchant_6 = Merchant.create!(name: "That's A-Door-A-Bell")

    @item_1 = Item.create!(name: "Star Wars Ladle", description: "May the soup be with you", unit_price: 10, merchant_id: @merchant_1.id)
    @item_2 = Item.create!(name: "Sparkle Ladle", description: "Serve in style", unit_price: 12, merchant_id: @merchant_2.id)
    @item_3 = Item.create!(name: "Green Ladle", description: "It is green", unit_price: 15, merchant_id: @merchant_3.id)
    @item_4 = Item.create!(name: "Purple Ladle", description: "It is purple", unit_price: 17, merchant_id: @merchant_4.id)
    @item_5 = Item.create!(name: "Yellow Ladle", description: "It is yellow", unit_price: 14, merchant_id: @merchant_5.id)
    @item_6 = Item.create!(name: "Orange Ladle", description: "It is orange", unit_price: 20, merchant_id: @merchant_6.id)
    @item_7 = Item.create!(name: "Black Ladle", description: "It is black", unit_price: 5, merchant_id: @merchant_1.id)
    @item_8 = Item.create!(name: "Rainbow Ladle", description: "It is beautiful", unit_price: 7, merchant_id: @merchant_1.id)
    @item_9 = Item.create!(name: "Black Ladle Handle Grip", description: "It is black and provides a sturdy grip", unit_price: 2, merchant_id: @merchant_1.id)
    @item_10 = Item.create!(name: "Blue Ladle Handle Grip", description: "It is blue", unit_price: 2, merchant_id: @merchant_1.id)
    @item_11 = Item.create!(name: "Sport Ladle", description: "Take your soup serving to the extreme!", unit_price: 15, merchant_id: @merchant_1.id)

    @customer_1 = Customer.create!(first_name: "Sally", last_name: "Brown")
    @customer_2 = Customer.create!(first_name: "Morgan", last_name: "Freeman")

    @invoice_1 = Invoice.create!(status: 1, customer_id: @customer_1.id)
    @invoice_2 = Invoice.create!(status: 1, customer_id: @customer_1.id)
    @invoice_3 = Invoice.create!(status: 1, customer_id: @customer_2.id)
    @invoice_4 = Invoice.create!(status: 1, customer_id: @customer_2.id)

    @ii_1 = InvoiceItem.create!(quantity: 5, unit_price: 10, status: 0, item_id: @item_1.id, invoice_id: @invoice_1.id)
    @ii_2 = InvoiceItem.create!(quantity: 5, unit_price: 12, status: 2, item_id: @item_2.id, invoice_id: @invoice_1.id)
    @ii_3 = InvoiceItem.create!(quantity: 5, unit_price: 15, status: 0, item_id: @item_3.id, invoice_id: @invoice_2.id)
    @ii_4 = InvoiceItem.create!(quantity: 5, unit_price: 17, status: 2, item_id: @item_4.id, invoice_id: @invoice_2.id)
    @ii_5 = InvoiceItem.create!(quantity: 5, unit_price: 14, status: 0, item_id: @item_5.id, invoice_id: @invoice_1.id)
    @ii_6 = InvoiceItem.create!(quantity: 5, unit_price: 20, status: 2, item_id: @item_6.id, invoice_id: @invoice_1.id)
    @ii_7 = InvoiceItem.create!(quantity: 5, unit_price: 40, status: 0, item_id: @item_7.id, invoice_id: @invoice_3.id)
    @ii_8 = InvoiceItem.create!(quantity: 5, unit_price: 5, status: 2, item_id: @item_8.id, invoice_id: @invoice_2.id)
    @ii_9 = InvoiceItem.create!(quantity: 5, unit_price: 5, status: 2, item_id: @item_9.id, invoice_id: @invoice_2.id)
    @ii_10 = InvoiceItem.create!(quantity: 5, unit_price: 5, status: 2, item_id: @item_10.id, invoice_id: @invoice_2.id)
    @ii_11 = InvoiceItem.create!(quantity: 5, unit_price: 5, status: 0, item_id: @item_11.id, invoice_id: @invoice_2.id)

    @transaction_1 = Transaction.create!(credit_card_number: "5522 3344 8811 7777", credit_card_expiration_date: "2025-05-17", result: 0, invoice_id: @invoice_1.id)
    @transaction_2 = Transaction.create!(credit_card_number: "5555 4444 3333 2222", credit_card_expiration_date: "2023-02-11", result: 0, invoice_id: @invoice_1.id)
    @transaction_3 = Transaction.create!(credit_card_number: "5551 4244 3133 2622", credit_card_expiration_date: "2027-01-01", result: 0, invoice_id: @invoice_1.id)
    @transaction_4 = Transaction.create!(credit_card_number: "5775 4774 3373 2722", credit_card_expiration_date: "2030-07-22", result: 0, invoice_id: @invoice_2.id)
    @transaction_5 = Transaction.create!(credit_card_number: "5773 4374 4373 2622", credit_card_expiration_date: "2027-11-24", result: 0, invoice_id: @invoice_2.id)
    @transaction_6 = Transaction.create!(credit_card_number: "5235 2374 3233 2322", credit_card_expiration_date: "2023-03-23", result: 0, invoice_id: @invoice_2.id)
    @transaction_7 = Transaction.create!(credit_card_number: "5233 2322 3211 2300", credit_card_expiration_date: "2021-12-23", result: 1, invoice_id: @invoice_3.id)
  end

  describe 'relationships' do
    it {should have_many :items}
    it {should have_many(:invoice_items).through(:items)}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should have_many(:bulk_discounts)}
    it {should have_many(:bulk_discounts).through(:merchant_discounts)}



  end

  describe 'class methods' do
    it 'returns the top five items by revenue' do
      results = @merchant_1.top_5.map do |merchant|
        merchant.name
      end
      expect(results).to eq([@item_1.name, @item_8.name, @item_9.name, @item_10.name, @item_11.name])
    end

    it 'returns the top 5 merchants based on revenue' do
      results = Merchant.big_5.map do |merchant|
        merchant.name
      end
      expect(results).to eq([@merchant_1.name, @merchant_6.name, @merchant_4.name, @merchant_3.name, @merchant_5.name])
    end

    it 'can test for enabled merchants' do
      enabled = Merchant.enabled?

      expect(enabled).to eq([@merchant_1, @merchant_2, @merchant_5, @merchant_6])
    end

    it 'can test for disabled merchants' do
      disabled = Merchant.disabled?.first

      expect(disabled).to eq(@merchant_3)
    end

    it 'returns the top five item names by revenue' do
      expect(@merchant_1.top_5).to eq([@item_1, @item_8, @item_9, @item_10, @item_11])
    end
  end

  describe 'instance methods' do
    it 'returns top 5 customers by transaction count with a specific merchant' do
      expect(@merchant_1.favorite_customers).to eq([@customer_1])
    end
  end
end
