class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  # enum value_type: { percent: 0, dollars: 1 }
end