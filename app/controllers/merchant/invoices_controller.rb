class Merchant::InvoicesController < ApplicationController 
  def index 
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices.distinct
  end

  def show
    @invoice = Invoice.find(params[:id])
    @merchant = @merchant = Merchant.find(params[:merchant_id])
    @subtotal = @invoice.merchant_subtotal(@merchant)
    @straight_up_revenue = @invoice.merchant_rev_with_coupons
    @no_coupon_revenue = @invoice.merchant_subtotal(@merchant)
  end
end