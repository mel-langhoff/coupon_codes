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
    @merchant = Merchant.find(params[:merchant_id])
    coupon = @merchant.coupons.find_by(id: params[:id])
    if coupon.pending_invoices? == true
      flash[:error] = "Error. Can't change coupon to inactive if there are pending invoices."
      redirect_to merchant_coupon_path(@merchant, coupon)
    else
      if coupon.active
        coupon.update(active: false)
        flash[:notice] = "Coupon successfully changed to inactive"
        redirect_to merchant_coupon_path(@merchant, coupon)
      else
        coupon.update(active: true)
        flash[:notice] = "Coupon successfully changed to active"
        redirect_to merchant_coupon_path(@merchant, coupon)
      end
    end
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    coupon = Coupon.new(coupon_params)
    if coupon.save
      # flash[:alert] = "Coupon saved successfully!"
      redirect_to merchant_coupons_path(merchant)
    else
      # flash[:error] = "Error: please fill out all information and be sure coupon code is unique."
      redirect_to new_merchant_coupon_path(merchant)
    end
  end

  private

  def coupon_params
    params.permit(:name, :code, :active, :value_type, :value_off, :merchant_id)
  end
end