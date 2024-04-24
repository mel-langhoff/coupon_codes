require 'rails_helper'

RSpec.describe "Merchant Invoices Show" do
  before(:each) do
    @merchant1 = create(:merchant, id: 1)
    @merchant2 = create(:merchant, id: 2)

    @items_list1 = create_list(:item, 4, merchant: @merchant1 )
    @item1 = @items_list1[0]
    @item2 = @items_list1[1]
    @item3 = @items_list1[2]
    @item4 = @items_list1[3]

    @items_list2 = create_list(:item, 2, merchant: @merchant2 )
    @item5 = @items_list2[0]
    @item6 = @items_list2[1]

    @customers = create_list(:customer, 4)
    @customer1 = @customers[0]
    @customer2 = @customers[1]
    @customer3 = @customers[2]
    @customer4 = @customers[3]
    @customer5 = create(:customer) 

    @invoice1 = create(:invoice, customer: @customer1, created_at: Time.utc(2004, 9, 13, 12, 0, 0))
    @invoice2 = create(:invoice, customer: @customer5, created_at: Time.utc(2006, 1, 12, 1, 0, 0))

    @invoice_item1 = create(:invoice_item, item_id: @item1.id, invoice_id: @invoice1.id, status: 0)
    @invoice_item2 = create(:invoice_item, item_id: @item2.id, invoice_id: @invoice1.id, status: 0)
    @invoice_item3 = create(:invoice_item, item_id: @item5.id, invoice_id: @invoice2.id, status: 2)

    visit merchant_invoice_path(@merchant1, @invoice1)
  end

  describe '#User Story 15' do
    it 'displays the invoice id and status' do
      expect(page).to have_content(@invoice1.id)
      expect(page).to have_content(@invoice1.status)
    end

    it 'displays the invoice creation date in [Monday, July 18, 2019] format' do
      expect(page).to have_content("Monday, September 13, 2004")
    end

    it 'displays the customers first and last name' do
      expect(page).to have_content(@customer1.first_name)
      expect(page).to have_content(@customer1.last_name)
    end
  end

  describe '#User Story 16' do
    it 'displays all items on that invoice' do
      expect(page).to have_content(@item1.name)
      expect(page).to have_content(@item2.name)
      expect(page).to_not have_content(@item5.name)
    end

    it 'displays the quantity, unit_price and status for each item' do
      within "#invoice-item#{@invoice_item1.id}" do
        expect(page).to have_content("Item Name: #{@invoice_item1.item.name}")
        expect(page).to have_content("Total Price: #{@invoice_item1.unit_price}")
        expect(page).to have_content("Status: #{@invoice_item1.status}")
      end

      within "#invoice-item#{@invoice_item2.id}" do
        expect(page).to have_content("Item Name: #{@invoice_item2.item.name}")
        expect(page).to have_content("Total Price: #{@invoice_item2.unit_price}")
        expect(page).to have_content("Status: #{@invoice_item2.status}")
      end
    end
  end

  describe '#User story 17' do
  it 'displays the total revenue from all items on the invoice' do
    within "#total-revenue" do
      expect(page).to have_content("Revenue from all items: $#{@invoice1.total_revenue_in_dollars}")
      end
    end
  end

  describe '#User Story 18' do
    it "displays each items status as a select field with the current status displayed" do
      within "#invoice-item#{@invoice_item1.id}" do
        expect(page).to have_select('Status', with_options: ['pending', 'packaged', 'shipped'])
        expect(page).to have_select('Status', selected: 'pending')
      end
      within "#invoice-item#{@invoice_item2.id}" do
        expect(page).to have_select('Status', with_options: ['pending', 'packaged', 'shipped'])
        expect(page).to have_select('Status', selected: 'pending')
      end
    end

    it "when I click the select field, I can select a new status and click 'Update Item Status' and be redirected to the show page, seeing the status updated" do
      within "#invoice-item#{@invoice_item1.id}" do
        expect(page).to have_select('Status', with_options: ['pending', 'packaged', 'shipped'])
        expect(page).to have_select('Status', selected: 'pending')

        page.select 'packaged', from: 'Status'
        expect(page).to have_select('Status', selected: 'packaged')

        expect(page).to have_button("Update Item Status")
        click_on "Update Item Status"
      end

      expect(current_path).to eq(merchant_invoice_path(@merchant1, @invoice1))

      within "#invoice-item#{@invoice_item1.id}" do
        expect(page).to have_select('Status', selected: 'packaged')
        expect(page).to_not have_select('Status', selected: 'pending')
      end
    end
  end

  describe 'Coupon User Story 7' do
      it 'displays the subtotal and Merchant Revenue With Coupons with coupons' do    
        merchant = Merchant.create(name: 'Test Merchant', status: 1)
        customer = Customer.create(first_name: 'Test', last_name: 'Customer')
        
        coupon1 = Coupon.create(name: '10% Off', code: '000', merchant: merchant, value_type: 'percentage', value_off: 10, active: true, usage_amount: 0)
        coupon2 = Coupon.create(name: '$5 Off', code: 'sdfsadfsf', merchant: merchant, value_type: 'dollars', value_off: 5, active: true, usage_amount: 0)
        
        invoice1 = Invoice.create(status: 0, customer: customer, coupon: coupon1) # in progress status
        invoice2 = Invoice.create(status: 1, customer: customer, coupon: coupon2) # completed status
        
        item1 = Item.create(name: 'Test Item 1', description: 'Description1', unit_price: 200, merchant: merchant, status: 1)
        invoice_item1 = InvoiceItem.create(invoice: invoice1, item: item1, quantity: 3, unit_price: 200, status: 0)
        
        item2 = Item.create(name: 'Test Item 2', description: 'Description2', unit_price: 100, merchant: merchant, status: 1)
        invoice_item2 = InvoiceItem.create(invoice: invoice2, item: item2, quantity: 2, unit_price: 100, status: 0)
        
        subtotal = invoice1.merchant_subtotal(merchant)
        merch_rev = invoice1.merchant_rev_with_coupons

        visit merchant_invoice_path(merchant, invoice1)
        
        expect(page).to have_content("Subtotal Without Coupons: 5.4")
        expect(page).to have_content("Merchant Revenue With Coupons: 6.0")
    end
  end
end
