require "rails_helper"

RSpec.describe "Admin Merchants Index" do
  before(:each) do
    @merchant1 = Merchant.create(name: "Amazon")
    @merchant2 = Merchant.create(name: "Walmart")
    @merchant3 = Merchant.create(name: "Target", status: 1)
   
  end

  describe '#us 24' do
    it 'see each merchant on the page ' do
      # When I visit the admin merchants index (/admin/merchants)
      visit admin_merchants_path
      # Then I see the name of each merchant in the system
      expect(page).to have_content(@merchant1.name)
      expect(page).to have_content(@merchant2.name)
      expect(page).to have_content(@merchant3.name)
     
    end
  end

  describe '#us 25' do
    it 'see a specific merchants show page ' do
      visit admin_merchants_path
      # When I click on the name of a merchant from the admin merchants index page (/admin/merchants),
      expect(page).to have_link("#{@merchant1.name}")
      # require 'pry'; binding.pry
      click_on("#{@merchant1.name}")
      # Then I am taken to that merchant's admin show page (/admin/merchants/:merchant_id)
      expect(current_path).to eq(admin_merchant_path(@merchant1.id))
      # And I see the name of that merchant
      expect(page).to have_content("#{@merchant1.name}")
    end
  end

  describe '#us 27' do
    it 'has a button of enable or disable' do
      # When I visit the admin merchants index (/admin/merchants)
      visit admin_merchants_path
      # Then next to each merchant name I see a button to disable or enable that merchant.
      within ".enabled" do
        expect(page).to have_button("Disable #{@merchant1.name}")
        # When I click this button
        click_on("Disable #{@merchant1.name}")
      end
      # Then I am redirected back to the admin merchants index
      expect(current_path).to eq(admin_merchants_path)
      # And I see that the merchant's status has changed
      within ".disabled" do
        expect(page).to have_button("Enable #{@merchant1.name}")
        # expect(page).to have_content("Status: Disabled")
      end
    end
  end

  describe '#us 28' do
    it 'Has a section one for enabled merchants and the other for disabled merchants' do

      # When I visit the admin merchants index (/admin/merchants)
      visit admin_merchants_path
      # Then I see two sections, one for "Enabled Merchants" and one for "Disabled Merchants"
      within ".enabled" do
        expect(page).to have_content("Enabled Merchants:")
        expect(page).to have_content("Amazon")
        expect(page).to have_content("Walmart")

      end
      # And I see that each Merchant is listed in the appropriate section

      within '.disabled' do
        expect(page).to have_content("Disabled Merchants:")
        expect(page).to have_content("Target")
      end
    end
  end

  describe '#us 30' do
    before(:each) do
      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)
      @merchant3 = create(:merchant)
      @merchant4 = create(:merchant)
      @merchant5 = create(:merchant)
      @merchant6 = create(:merchant)
      @merchant7 = create(:merchant)
      @merchant8 = create(:merchant)

      @invoice1 = create(:invoice)
      @invoice2 = create(:invoice)
      @invoice3 = create(:invoice)
      @invoice4 = create(:invoice)
      @invoice5 = create(:invoice)
      @invoice6 = create(:invoice)
      @invoice7 = create(:invoice)
      @invoice8 = create(:invoice)

      @item1 = create(:item, merchant: @merchant1)
      @item2 = create(:item, merchant: @merchant2)
      @item3 = create(:item, merchant: @merchant3)
      @item4 = create(:item, merchant: @merchant4)
      @item5 = create(:item, merchant: @merchant5)
      @item6 = create(:item, merchant: @merchant6)
      @item7 = create(:item, merchant: @merchant7)
      @item8 = create(:item, merchant: @merchant7)

      create_list(:invoice_item, 5, unit_price: 1000, quantity: 5, invoice: @invoice1, item: @item1)
      create_list(:invoice_item, 2, unit_price: 2000, quantity: 2, invoice: @invoice2, item: @item2)
      create_list(:invoice_item, 1, unit_price: 5000, quantity: 2, invoice: @invoice3, item: @item3)
      create_list(:invoice_item, 1, unit_price: 2000, quantity: 4, invoice: @invoice4, item: @item4)
      create_list(:invoice_item, 4, unit_price: 4000, quantity: 5, invoice: @invoice5, item: @item5)
      create_list(:invoice_item, 3, unit_price: 10000, quantity: 10, invoice: @invoice6, item: @item6)
      create_list(:invoice_item, 2, unit_price: 9000, quantity: 1, invoice: @invoice7, item: @item7)
      create_list(:invoice_item, 5, unit_price: 9000, quantity: 1, invoice: @invoice8, item: @item8)

      create(:transaction, result: 0, invoice: @invoice1)
      create(:transaction, result: 0, invoice: @invoice2)
      create(:transaction, result: 1, invoice: @invoice3)
      create(:transaction, result: 0, invoice: @invoice4)
      create(:transaction, result: 0, invoice: @invoice5)
      create(:transaction, result: 0, invoice: @invoice6)
      create(:transaction, result: 0, invoice: @invoice7)
      create(:transaction, result: 0, invoice: @invoice8)

      visit admin_merchants_path
    end

    it 'displays the names and total revenue of the top 5 merchants by total revenue generated' do
      within '.top_merchants' do
        expect(@merchant6.name).to appear_before(@merchant5.name)
        expect(@merchant5.name).to appear_before(@merchant7.name)
        expect(@merchant7.name).to appear_before(@merchant1.name)
        expect(@merchant1.name).to appear_before(@merchant2.name)

        expect(page).to_not have_content(@merchant3.name)
        expect(page).to_not have_content(@merchant4.name)
      end
    end

    it 'has links to that specific merchants show page' do
      within '.top_merchants' do
        expect(page).to have_link(@merchant6.name)
        expect(page).to have_link(@merchant5.name)
        expect(page).to have_link(@merchant7.name)
        expect(page).to have_link(@merchant1.name)
        expect(page).to have_link(@merchant2.name)

        click_on(@merchant2.name)

        expect(current_path).to eq admin_merchant_path(@merchant2)
      end
    end

    it 'displays the total revenue for each of the top merchants next to their name' do
      within '.top_merchants' do
        expect(page).to have_content("#{@merchant6.name} - $3,000.00 in sales")
        expect(page).to have_content("#{@merchant5.name} - $800.00 in sales")
        expect(page).to have_content("#{@merchant7.name} - $630.00 in sales")
        expect(page).to have_content("#{@merchant1.name} - $250.00 in sales")
        expect(page).to have_content("#{@merchant2.name} - $80.00 in sales")
      end
    end
  end
end

