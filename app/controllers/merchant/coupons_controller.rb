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
  end
end