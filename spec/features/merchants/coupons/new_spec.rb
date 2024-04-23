RSpec.describe "New Merchant Coupon Page" do
  before :each do
      @merchant1 = create(:merchant, id: 1)
      visit new_merchant_coupon_path(@merchant1)
  end

  describe 'Coupon User Story 2' do
      it 'has fields to create a new coupon' do
          expect(page).to have_field('Name')
          expect(page).to have_field('Unique Code')
          expect(page).to have_field('Type of Coupon')
          expect(page).to have_field('Value Off Amount')
          expect(page).to have_field('Active?')
      end

      it 'will provide a message and create a new coupon' do
          fill_in 'Name', with: 'Sample Coupon'
          fill_in 'Unique Code', with: 'SC12345'
          fill_in 'Value Off Amount', with: '10'
          select "percent", from: 'Type of Coupon'
          check 'Active?'

          click_on 'Create New Coupon'

          coupon = Coupon.find_by(unique_code: 'SC12345')

          expect(current_path).to eq merchant_coupons_path(@merchant1)
          expect(page).to have_content('Sample Coupon')
          expect(page).to have_content("Coupon saved successfully!")
          expect(page).to have_content("Amount off: 10%")
          expect(page).to have_content('SC12345')
      end

      it 'will redirect to index with new coupon listed' do
          fill_in 'Name', with: 'Sample Coupon'
          fill_in 'Unique Code', with: 'SC12345'
          select 'percent', from: 'Type of Coupon'
          fill_in 'Value Off Amount', with: '10'
          check 'Active?'

          click_on 'Create New Coupon'

          coupon = Coupon.find_by(unique_code: 'SC12345')

          expect(current_path).to eq merchant_coupons_path(@merchant1)
          expect(page).to have_content('Sample Coupon')
          expect(page).to have_content("Coupon saved successfully!")
          expect(page).to have_content("Amount off: 10%")
          expect(page).to have_content('SC12345')
          expect(page).to have_link('View Coupon Details', href: merchant_coupon_path(@merchant1, coupon))
      end

      it 'will provide an error and redirect to new page if info is incorrect at submission' do
          fill_in 'Name', with: 'Sample Coupon'
          fill_in 'Unique Code', with: 'SC12345'
          select 'percent', from: 'Type of Coupon'
          fill_in 'Value Off Amount', with: '10'
          check 'Active?'

          click_on 'Create New Coupon'

          coupon = Coupon.find_by(unique_code: 'SC12345')

          expect(current_path).to eq new_merchant_coupon_path(@merchant1)
          expect(page).to have_field('Name')
          expect(page).to have_field('Unique Code')
          expect(page).to have_field('Type of Coupon')
          expect(page).to have_field('Value Off Amount')
          expect(page).to have_field('Active?')
          expect(page).to have_content(coupon.errors)
      end
    end
  end
end
