require 'rails_helper'

RSpec.describe 'The Admin Merchant Show page', type: :feature do
  let!(:merchant_1) { create(:merchant) }

  describe 'when a user visits the admin merchant show page' do 
    it 'shows the name of the merchant' do 
      visit admin_merchant_path(merchant_1)

      expect(page).to have_content(merchant_1.name)
    end 

    describe 'update Merchant form' do
      it "has a link to update the merchant's information" do
        visit admin_merchant_path(merchant_1)

        click_link "Update Merchant"

        expect(current_path).to eq edit_admin_merchant_path(merchant_1)
        expect(page).to have_field('Name', with: "#{merchant_1.name}")
      end

      it 'redirects to the admin merchant show page once submitted and shows the updated merchant name' do
        visit edit_admin_merchant_path(merchant_1)

        fill_in 'Name', with: 'Charlie'
        click_button 'Save'

        expect(current_path).to eq admin_merchant_path(merchant_1)
        expect(page).to have_content("Charlie")
      end

      it "shows a flash message if update was successful" do
        visit edit_admin_merchant_path(merchant_1)

        fill_in 'Name', with: 'Charlie'
        click_button 'Save'

        expect(current_path).to eq admin_merchant_path(merchant_1)
        expect(page).to have_content("Charlie")
        expect(page).to have_content('Merchant Information Successfully Updated')
      end

      it 'will show an error message if update was not successful' do
        visit edit_admin_merchant_path(merchant_1)

        fill_in 'Name', with: ''
        click_button 'Save'
        
        expect(current_path).to eq edit_admin_merchant_path(merchant_1)
        expect(page).to have_content('Name field must not be empty. Please fill out and resubmit.')
      end
    end
  end 
end

