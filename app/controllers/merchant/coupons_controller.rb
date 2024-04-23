class Merchant::CouponsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @coupons = @merchant.coupons
    @active_coupons = @coupons.active_coupons
    @inactive_coupons = @coupons.inactive_coupons
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = @merchant.coupons.find_by(id: params[:id])
    @usage_count = @coupon.usage_count
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find_by(id: params[:id])
    if coupon.pending_invoices?
      flash[:error] = "Error. Can't change coupon to inactive if there are pending invoices."
    else
      if coupon.active
        coupon.update(active: false)
        flash[:notice] = "Coupon successfully changed to inactive"
      else
        coupon.update(active: true)
        flash[:notice] = "Coupon successfully changed to active"
      end
    end

    redirect_to merchant_coupon_path(merchant, coupon)
  end
end