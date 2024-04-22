class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  def self.active_coupons
    where(active: true)
  end

  def self.inactive_coupons
    where(active: false)
  end

  def usage_count
    invoices.joins(:transactions).where(transactions: { result: 0 }).count
  end
end