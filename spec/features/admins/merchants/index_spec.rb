require 'rails_helper'

RSpec.describe 'The Admin Merchant Index page', type: :feature do
  let!(:merchant_1) { create(:disabled_merchant) }
  let!(:merchant_2) { create(:disabled_merchant) }
  let!(:merchant_3) { create(:disabled_merchant) }
  let!(:merchant_4) { create(:enabled_merchant) }
  let!(:merchant_5) { create(:enabled_merchant) }

  describe 'when a user visits the admin merchant index page' do 
    it 'lists the name of each merchant in the system' do 
      visit admin_merchants_path

      expect(page).to have_content(merchant_1.name)
      expect(page).to have_content(merchant_2.name)
      expect(page).to have_content(merchant_3.name)
      expect(page).to have_content(merchant_4.name)
      expect(page).to have_content(merchant_5.name)
    end

    it 'has a link for each merchant name to the admin merchant show page' do
      visit admin_merchants_path

      expect(page).to have_link(merchant_1.name)
      expect(page).to have_link(merchant_2.name)
      expect(page).to have_link(merchant_3.name)
      expect(page).to have_link(merchant_4.name)
      expect(page).to have_link(merchant_5.name)

      click_link(merchant_1.name)

      expect(current_path).to eq(admin_merchant_path(merchant_1))

      visit admin_merchants_path

      click_link(merchant_2.name)

      expect(current_path).to eq(admin_merchant_path(merchant_2))
    end
    
    describe 'enable and disable' do
      it 'has an enable or disable button next to each merchant' do
        visit admin_merchants_path

        within "#merchant_#{merchant_1.id}" do 
          expect(page).to have_button "Enable Merchant"
          expect(page).to_not have_button "Disable Merchant"
        end 

        within "#merchant_#{merchant_2.id}" do 
          expect(page).to have_button "Enable Merchant"
        end 

        within "#merchant_#{merchant_3.id}" do 
          expect(page).to have_button "Enable Merchant"
        end 
       
        within "#merchant_#{merchant_4.id}" do 
          expect(page).to have_button "Disable Merchant"
          expect(page).to_not have_button "Enable Merchant"
        end 

        within "#merchant_#{merchant_5.id}" do 
          expect(page).to have_button "Disable Merchant"
        end 
      end

      it "will update a merchant's status" do
        visit admin_merchants_path

        expect(merchant_1.status).to eq('disabled')
        expect(merchant_5.status).to eq('enabled')

        click_button "Disable #{merchant_5.name}"

        expect(current_path).to eq admin_merchants_path
        expect(Merchant.find(merchant_5.id).status).to eq('disabled')


        click_button "Enable #{merchant_1.name}"

        expect(current_path).to eq admin_merchants_path
        expect(Merchant.find(merchant_1.id).status).to eq('enabled')
      end
    end 
  end
end