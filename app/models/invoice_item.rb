class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  validates :quantity, presence: true, numericality: true
  validates :unit_price, presence: true, numericality: true
  validates :status, presence: true

  enum status: { "pending" => 0, 
                 "packaged" => 1, 
                 "shipped" => 2 }

  def unit_price_in_dollars
    self.unit_price / 100.00
  end
end