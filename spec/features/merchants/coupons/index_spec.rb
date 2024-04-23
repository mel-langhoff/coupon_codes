require 'rails_helper'

RSpec.describe 'Merchant Coupons Index Page' do
  before(:each) do
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant, name: "Amazon")

    @customers = create_list(:customer, 10)
    @customer1 = @customers[0]
    @customer2 = @customers[1]
    @customer3 = @customers[2]
    @customer4 = @customers[3]
    @customer5 = @customers[4]
    @customer6 = @customers[5]

    @coupon1 = create(:coupon, name: "Coupon1", merchant: @merchant1, code: "DISCOUNT10", value_off: 10, value_type: "percent", id: 1, active: false)
    @coupon2 = create(:coupon, name: "Coupon2", merchant: @merchant1, code: "SAVE20", value_off: 20, value_type: "dollars", id: 2, active: false)
    @coupon3 = create(:coupon, name: "Coupon3", merchant: @merchant1, code: "DISCOUNT20", value_off: 20, value_type: "percent", id: 3, active: true)
    @coupon4 = create(:coupon, name: "Coupon4", merchant: @merchant1, code: "SAVE40", value_off: 40, value_type: "dollars", id: 4, active: true)

    @invoices = create_list(:invoice, 3, customer: @customer1, coupon: @coupon1)
    @invoice1 = @invoices[0]
    @invoice2 = @invoices[1]
    @invoice3 = @invoices[2]
    @invoice4 = create(:invoice, customer_id: @customer2.id, created_at: Time.utc(2004, 9, 13, 12, 0, 0), coupon: @coupon1)
    @invoice5 = create(:invoice, customer_id: @customer3.id, created_at: Time.utc(2006, 1, 12, 1, 0, 0), coupon: @coupon2)
    @invoice6 = create(:invoice, customer_id: @customer4.id, created_at: Time.utc(2024, 4, 5, 12, 0, 0), coupon: @coupon2)
    @invoice7 = create(:invoice, customer_id: @customer5.id, created_at: Time.utc(2024, 4, 6, 12, 0, 0), coupon: @coupon2)
    @invoice8 = create(:invoice, customer_id: @customer6.id, created_at: Time.utc(2024, 4, 7, 12, 0, 0), coupon: @coupon2)

    @invoice1_transactions = create_list(:transaction, 5, invoice: @invoice1)
    @transaction1 = @invoice1_transactions[0]
    @transaction2 = @invoice1_transactions[1]
    @transaction3 = @invoice1_transactions[2]
    @transaction4 = @invoice1_transactions[3]
    @transaction5 = @invoice1_transactions[4]

    @invoice4_transactions = create_list(:transaction, 4, invoice: @invoice4)
    @transaction6 = @invoice4_transactions[0]
    @transaction7 = @invoice4_transactions[1]
    @transaction8 = @invoice4_transactions[2]
    @transaction9 = @invoice4_transactions[3]

    @invoice5_transactions = create_list(:transaction, 3, invoice: @invoice5)
    @transaction10 = @invoice5_transactions[0]
    @transaction11 = @invoice5_transactions[1]
    @transaction12 = @invoice4_transactions[2]

    @invoice6_transactions = create_list(:transaction, 2, invoice: @invoice6)
    @transaction13 = @invoice6_transactions[0]
    @transaction14 = @invoice6_transactions[1]

    @invoice7_transactions = create_list(:transaction, 1, invoice: @invoice7)
    @transaction15 = @invoice7_transactions[0]
   
    @transaction16 = create(:transaction, invoice_id: @invoice2.id)
    @transaction17 = create(:transaction, invoice_id: @invoice3.id)
    @transaction18 = create(:transaction, invoice_id: @invoice6.id)
    @transaction19 = create(:transaction, invoice_id: @invoice7.id)

    @item1 = create(:item, unit_price: 1, merchant_id: @merchant1.id, created_at: Time.utc(2024, 4, 1, 12, 0, 0))
    @item2 = create(:item, unit_price: 23, merchant_id: @merchant1.id, created_at: Time.utc(2024, 4, 2, 12, 0, 0))
    @item3 = create(:item, unit_price: 100, merchant_id: @merchant1.id, created_at: Time.utc(2024, 4, 3, 12, 0, 0))
    @item4 = create(:item, unit_price: 5, merchant_id: @merchant1.id, created_at: Time.utc(2024, 4, 4, 12, 0, 0))
    @item5 = create(:item, unit_price: 12, merchant_id: @merchant1.id, created_at: Time.utc(2024, 4, 5, 12, 0, 0))
    @item6 = create(:item, unit_price: 12, merchant_id: @merchant1.id, created_at: Time.utc(2024, 4, 5, 12, 0, 0))
    @item7 = create(:item, unit_price: 12, merchant_id: @merchant1.id, created_at: Time.utc(2024, 4, 5, 12, 0, 0))
    @item8 = create(:item, unit_price: 12, merchant_id: @merchant1.id, created_at: Time.utc(2024, 4, 5, 12, 0, 0))
    @item9 = create(:item, unit_price: 12, merchant_id: @merchant1.id, created_at: Time.utc(2024, 4, 5, 12, 0, 0))
    @item10 = create(:item, unit_price: 12, merchant_id: @merchant1.id, created_at: Time.utc(2024, 4, 5, 12, 0, 0))

    @invoice_item1 = create(:invoice_item, item_id: @item1.id, invoice_id: @invoice1.id, status: 0)
    @invoice_item2 = create(:invoice_item, item_id: @item2.id, invoice_id: @invoice1.id, status: 2)
    @invoice_item3 = create(:invoice_item, item_id: @item3.id, invoice_id: @invoice2.id, status: 2)
    @invoice_item4 = create(:invoice_item, item_id: @item4.id, invoice_id: @invoice4.id, status: 1)
    @invoice_item5 = create(:invoice_item, item_id: @item5.id, invoice_id: @invoice4.id, status: 1)
    @invoice_item6 = create(:invoice_item, item_id: @item5.id, invoice_id: @invoice4.id, status: 1)
    @invoice_item7 = create(:invoice_item, item_id: @item5.id, invoice_id: @invoice5.id, status: 1)
    @invoice_item8 = create(:invoice_item, item_id: @item5.id, invoice_id: @invoice5.id, status: 1)
    @invoice_item9 = create(:invoice_item, item_id: @item5.id, invoice_id: @invoice6.id, status: 1)
    @invoice_item10 = create(:invoice_item, item_id: @item5.id, invoice_id: @invoice7.id, status: 1)
    @invoice_item11 = create(:invoice_item, item_id: @item6.id, invoice_id: @invoice4.id, status: 1)
    @invoice_item12 = create(:invoice_item, item_id: @item7.id, invoice_id: @invoice5.id, status: 1)
    @invoice_item13 = create(:invoice_item, item_id: @item8.id, invoice_id: @invoice6.id, status: 1)
    @invoice_item14 = create(:invoice_item, item_id: @item9.id, invoice_id: @invoice7.id, status: 1)
    @invoice_item15 = create(:invoice_item, item_id: @item10.id, invoice_id: @invoice8.id, status: 1)
  
    visit merchant_coupons_path(@merchant1)

  end

  describe 'Coupon User Story 1' do
    it 'has a coupons details' do
      within "##{@coupon4.id}-details" do
        expect(page).to have_content(@coupon4.name)
        expect(page).to have_content("Amount off: 40 dollars")
        expect(page).to have_link('View Coupon Details', href: merchant_coupon_path(@merchant1, @coupon4))
      end
    end
  end

  describe 'Coupon User Story 6' do
    it 'lists all inactive coupons together' do
      within "#inactive-coupons" do
        expect(page).to have_content(@coupon1.name)
        expect(page).to have_content(@coupon2.name)
        expect(page).to_not have_content(@coupon3.name)
        expect(page).to_not have_content(@coupon4.name)
      end
    end

    it 'lists all active coupons together' do
      within "#active-coupons" do
        expect(page).to have_content(@coupon3.name)
        expect(page).to have_content(@coupon4.name)
        expect(page).to_not have_content(@coupon1.name)
        expect(page).to_not have_content(@coupon2.name)
      end
    end
  end

  describe 'Coupon User Story 2' do
    it 'has a link go to the new coupon page' do
      expect(page).to have_link('Create New Coupon', href: new_merchant_coupon_path(@merchant1))

      click_on 'Create New Coupon'
      expect(current_path).to eq new_merchant_coupon_path(@merchant1)
      expect(page).to have_field('Name')
      expect(page).to have_field('Unique Code')
      expect(page).to have_field('Type of Coupon')
      expect(page).to have_field('Value Off Amount')
      expect(page).to have_unchecked_field('Active?')
    end
  end
end
