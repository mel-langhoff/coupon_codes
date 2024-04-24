require "rails_helper"

RSpec.describe Invoice, type: :model do

  describe "relationships" do
    it { should belong_to(:customer) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items) }
    it { should have_many(:merchants) }
    it { should belong_to(:coupon).optional }
  end

  before(:each) do
    @customers = create_list(:customer, 10)
    @customer1 = @customers[0]
    @customer2 = @customers[1]
    @customer3 = @customers[2]
    @customer4 = @customers[3]
    @customer5 = @customers[4]
    @customer6 = @customers[5]

    @invoice1 = create(:invoice, customer: @customer1, created_at:  Time.utc(2004, 9, 13, 12, 0, 0) )
    @invoices = create_list(:invoice, 2, customer: @customer1)
    @invoice2 = @invoices[0]
    @invoice3 = @invoices[1]
    @invoice4 = create(:invoice, customer_id: @customer2.id, created_at: Time.utc(2004, 9, 13, 12, 0, 0))
    @invoice5 = create(:invoice, customer_id: @customer3.id, created_at: Time.utc(2006, 1, 12, 1, 0, 0))
    @invoice6 = create(:invoice, customer_id: @customer4.id, created_at: Time.utc(2024, 4, 5, 12, 0, 0))
    @invoice7 = create(:invoice, customer_id: @customer5.id, created_at: Time.utc(2024, 4, 6, 12, 0, 0))
    @invoice8 = create(:invoice, customer_id: @customer6.id, created_at: Time.utc(2024, 4, 7, 12, 0, 0))

    @invoice1_transactions = create_list(:transaction, 4, invoice: @invoice1)
    @invoice4_transactions = create_list(:transaction, 3, invoice: @invoice4)
    @invoice5_transactions = create_list(:transaction, 2, invoice: @invoice5)

    @transaction1 = @invoice1_transactions[0]
    @transaction2 = @invoice1_transactions[1]
    @transaction3 = @invoice1_transactions[2]
    @transaction4 = @invoice1_transactions[3]
    @transaction5 = @invoice4_transactions[0]
    @transaction6 = @invoice4_transactions[1]
    @transaction7 = @invoice4_transactions[2]
    @transaction8 = @invoice5_transactions[0]
    @transaction9 = @invoice5_transactions[1]
    @transaction10 = create(:transaction, invoice_id: @invoice2.id)
    @transaction11 = create(:transaction, invoice_id: @invoice3.id)
    @transaction12 = create(:transaction, invoice_id: @invoice6.id)
    @transaction13 = create(:transaction, invoice_id: @invoice7.id)

    @merchant1 = create(:merchant, name: "Amazon")

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

  end

  describe "class methods" do
    describe "#incomplete_invoices" do
      it "displays all invoices that haven't been shipped" do
        expect(Invoice.incomplete_invoices).to contain_exactly(@invoice1, @invoice4, @invoice5, @invoice6, @invoice7, @invoice8)
      end
    end

    describe '#best_day' do
      it 'returns a string that displays that merchants best selling day' do
        expect(@merchant1.invoices.best_day.strftime("%m/%d/%y")).to eq("09/13/04")
      end
    end
  end

  describe "instance methods" do
    describe '#merchant_rev_with_coupons' do
      it 'returns the merchant total revenue' do
        merchant = Merchant.create!(name: 'Test Merchant')
        customer = Customer.create!(first_name: 'John', last_name: 'Doe')
        item1 = Item.create!(name: 'Item 1', description: 'Test item 1', unit_price: 1000, merchant: merchant)
        item2 = Item.create!(name: 'Item 2', description: 'Test item 2', unit_price: 2000, merchant: merchant)
        coupon = Coupon.create!(name: 'Test Coupon', code: 'TESTCODE', merchant: merchant, value_type: 'percent', value_off: 20, active: true)
        
        invoice = Invoice.create!(status: 'completed', customer: customer, coupon: coupon)
        InvoiceItem.create!(invoice: invoice, item: item1, quantity: 5, unit_price: item1.unit_price, status: 1)
        InvoiceItem.create!(invoice: invoice, item: item2, quantity: 3, unit_price: item2.unit_price, status: 1)
        
        # subtotal
        expected_subtotal = (item1.unit_price * 5 + item2.unit_price * 3) / 100.0
        
        # grand total after applying coupon discounts
        discount = expected_subtotal * (coupon.value_off / 100.0)
        expected_grand_total = expected_subtotal - discount
        
        # grand total is calculated correctly
        grand_total = invoice.merchant_rev_with_coupons
        
        expect(grand_total).to eq(expected_grand_total)      
      end
    end
    describe "#merchant_subtotal" do
      it 'returns a subtotal for the merchant with coupons' do
        customer = Customer.create(first_name: 'Joe', last_name: 'Doe')
        merchant = Merchant.create(name: 'Merchant 1')

        item1 = Item.create(name: 'Item 1', description: 'Description 1', unit_price: 2000, merchant: merchant)
        item2 = Item.create(name: 'Item 2', description: 'Description 2', unit_price: 1000, merchant: merchant)

        invoice = Invoice.create(status: 'in progress', customer: customer)
        InvoiceItem.create(invoice: invoice, item: item1, quantity: 2, unit_price: 2000, status: "pending")
        InvoiceItem.create(invoice: invoice, item: item2, quantity: 3, unit_price: 1000, status: "pending")

        expected_subtotal = (2 * 2000 + 3 * 1000) / 100.0

        expect(invoice.merchant_subtotal(merchant)).to eq(expected_subtotal)
      end
      it 'applies a percent coupon' do
        customer = Customer.create(first_name: 'Joe', last_name: 'Doe')
        merchant = Merchant.create(name: 'Merchant 1')
    
        item1 = Item.create(name: 'Item 1', description: 'Description 1', unit_price: 2000, merchant: merchant)
        item2 = Item.create(name: 'Item 2', description: 'Description 2', unit_price: 1000, merchant: merchant)
    
        invoice = Invoice.create(status: 'in progress', customer: customer)
        InvoiceItem.create(invoice: invoice, item: item1, quantity: 2, unit_price: 2000, status: "pending")
        InvoiceItem.create(invoice: invoice, item: item2, quantity: 3, unit_price: 1000, status: "pending")
    
        total = invoice.merchant_rev_with_coupons
        expect(total).to eq(70.0)
      end
    end

    describe ".format_date" do
      it "formats date day, month, year" do
        expect(@invoice1.format_date).to eq("Monday, September 13, 2004")
      end
    end

    describe ".total_revenue" do
      it "returns the total revenue from all invoice items" do
        @cust1 = create(:customer)
        @inv1 = create(:invoice, customer_id: @cust1.id)
        @merch1 = create(:merchant)
        @it1 = create(:item, unit_price: 10000, merchant_id: @merch1.id)
        @it2 = create(:item, unit_price: 500, merchant_id: @merch1.id)
        @it3 = create(:item, unit_price: 7500, merchant_id: @merch1.id)
        @inv_it1 = @inv1.invoice_items.create!(item_id: @it1.id, quantity: 5, unit_price: @it1.unit_price, status: 0)
        @inv_it2 = @inv1.invoice_items.create!(item_id: @it2.id, quantity: 10, unit_price: @it2.unit_price, status: 0)
        @inv_it3 = @inv1.invoice_items.create!(item_id: @it3.id, quantity: 1, unit_price: @it3.unit_price, status: 0)

        expected_revenue = ((10000*5)+(500*10)+(7500*1))

        expect(@inv1.total_revenue).to eq(expected_revenue)
      end
    end

    describe ".total_revenue_in_dollars" do
      it "returns the total revenue from all invoice items in dollars" do
        @cust1 = create(:customer)
        @inv1 = create(:invoice, customer_id: @cust1.id)
        @merch1 = create(:merchant)
        @it1 = create(:item, unit_price: 10000, merchant_id: @merch1.id)
        @it2 = create(:item, unit_price: 500, merchant_id: @merch1.id)
        @it3 = create(:item, unit_price: 7500, merchant_id: @merch1.id)
        @inv_it1 = @inv1.invoice_items.create!(item_id: @it1.id, quantity: 5, unit_price: @it1.unit_price, status: 0)
        @inv_it2 = @inv1.invoice_items.create!(item_id: @it2.id, quantity: 10, unit_price: @it2.unit_price, status: 0)
        @inv_it3 = @inv1.invoice_items.create!(item_id: @it3.id, quantity: 1, unit_price: @it3.unit_price, status: 0)

        expected_revenue = ((10000*5)+(500*10)+(7500*1))/100.00

        expect(@inv1.total_revenue_in_dollars).to eq(expected_revenue)
      end
    end
  end
end