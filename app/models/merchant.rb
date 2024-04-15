class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  enum status: {"Enabled" => 0, "Disabled" => 1}

  
  def top_5_customers
    #binding.pry
    self.customers.select("customers.*, count(*) as count_transactions")
    .where("result = 0")
    .joins(:transactions)
    .group(:id)
    .order("count_transactions desc")
    .limit(5)
  end

  def self.top_five_merchants
    Merchant.joins(:transactions)
            .where("result = 0")
            .select("merchants.*, sum(invoice_items.quantity*invoice_items.unit_price) as total_revenue")
            .group(:id)
            .order("total_revenue desc")
            .limit(5)
  end
end