class Transaction < ApplicationRecord
  belongs_to :invoice
  enum result: [:success, :failed]

  # def top_5
  #   vip = Transaction.where(result: 0).joins(:invoice, :customers)

    # vip.map do |transactioninvoice|
    #   transactioninvoice.invoice.customer
    # end
    #
    # vip.order()
  end
end
