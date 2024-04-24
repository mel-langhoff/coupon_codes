class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  belongs_to :coupon, optional: true

  enum status: { "in progress" => 0, 
                 "completed" => 1, 
                 "cancelled" => 2 }

  def format_date
    self.created_at.strftime("%A, %B %d, %Y")
  end

  def self.incomplete_invoices
    select("invoices.*")
      .joins(:invoice_items)
      .where("invoice_items.status != 2")
      .distinct
      .order(:created_at)
  end

  def self.best_day
    self.joins(:invoice_items)
    .select("SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue, invoices.created_at")
    .group(:id)
    .order("revenue DESC")
    .order("invoices.created_at DESC")
    .first
    .created_at
  end

  def total_revenue
    invoice_items.sum("quantity * unit_price")
  end

  def total_revenue_in_dollars
    cents = self.total_revenue
    formatted_dollars = cents / 100.00
    formatted_dollars
  end

  # merch argu, got subtotal calc'ed by cents; subtot is calc'ed by sum of product of total_rev; returns amount in $ by divving by 100.to_f
  def merchant_subtotal(merchant)
    merchant_subtotal = self.items
                          .where(merchant: merchant)
                          .joins(:invoice_items)
                          .sum("invoice_items.unit_price * invoice_items.quantity") # total_revenue formula
    merchant_subtotal / 100.00
  end

  def merchant_revenue_grand_total
    total = total_revenue

    if coupon.present?
        # disc if %
        if coupon.value_type == 'percentage'
            discount = total * (coupon.value_off / 100.0)
            total -= discount
        # disc if $
        elsif coupon.value_type == 'dollars'
            total -= coupon.value_off
        end
        # is total 0?
        total = 0 if total < 0
    end

    total / 100.0
      end
end