require "rails_helper"

RSpec.describe "Admin Merchants Show" do
  before(:each) do
    @merchant1 = Merchant.create(name: "Amazon")
    @merchant2 = Merchant.create(name: "Walmart")
    @merchant3 = Merchant.create(name: "Target")
  end

  describe '#us 26' do
    it 'Update the merchant' do

      # When I visit a merchant's admin show page (/admin/merchants/:merchant_id)
      visit admin_merchant_path(@merchant1.id)
      # Then I see a link to update the merchant's information.
      expect(page).to have_link("Update #{@merchant1.name}")
      # When I click the link
      click_on("Update #{@merchant1.name}")
      # Then I am taken to a page to edit this merchant
      expect(current_path).to eq(edit_admin_merchant_path(@merchant1.id))
      # And I see a form filled in with the existing merchant attribute information
      # fill_in :name, with: "Dollar General"
      # When I update the information in the form and I click ‘submit’
      click_on "Submit"
      save_and_open_page
      # Then I am redirected back to the merchant's admin show page where I see the updated information
      expect(current_path).to eq(admin_merchant_path(@merchant1.id))
      # And I see a flash message stating that the information has been successfully updated.
      expect(page).to have_content("Succefully Updated")

    end
  end
end