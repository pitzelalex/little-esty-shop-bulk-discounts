require 'rails_helper'

RSpec.describe 'Admin Merchant Index page', type: :feature do
  let!(:merchant_1) { create(:merchant) }
  let!(:merchant_2) { create(:merchant) }
  let!(:merchant_3) { create(:merchant) }
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
        
        click_button "Enable #{merchant_1.name}"
        merchant_1.reload

        expect(current_path).to eq admin_merchants_path
        expect(merchant_1.status).to eq('enabled')

        click_button "Disable #{merchant_5.name}"
        merchant_5.reload

        expect(current_path).to eq admin_merchants_path
        expect(merchant_5.status).to eq('disabled')
      end

      it 'has a section with the enabled merchants' do
        visit admin_merchants_path

        expect(page).to have_content('Enabled Merchants')

        within "#enabled_merchants" do 
          expect(page).to have_content(merchant_4.name)
          expect(page).to have_content(merchant_5.name)
          expect(page).to_not have_content(merchant_2.name)
        end
      end 

      it 'has a section with the disabled merchants' do
        visit admin_merchants_path

        expect(page).to have_content('Disabled Merchants')

        within "#disabled_merchants" do 
          expect(page).to have_content(merchant_1.name)
          expect(page).to have_content(merchant_2.name)
          expect(page).to have_content(merchant_3.name)
          expect(page).to_not have_content(merchant_4.name)
          expect(page).to_not have_content(merchant_5.name)
        end
      end
    end 

    describe 'create a new merchant' do 
      it 'has a link to a form to create a new merchant' do 
        visit admin_merchants_path

        click_link("Create a New Merchant")

        expect(current_path).to eq new_admin_merchant_path

        expect(page).to have_field 'Name'
        expect(page).to have_button 'Create Merchant'
      end

      it 'will show the new merchant on the admin merchants index page once form is submitted' do 
        visit admin_merchants_path

        click_link("Create a New Merchant")

        fill_in 'Name', with: 'Betty Draper'
        click_button 'Create Merchant'
        
        betty_merchant = Merchant.last
        expect(current_path).to eq admin_merchants_path
        expect(page).to have_content("Betty Draper")
      end

      it 'will have the new merchant with a default status of disabled' do 
        visit admin_merchants_path

        click_link("Create a New Merchant")

        fill_in 'Name', with: 'Betty Draper'
        click_button 'Create Merchant'
        
        betty_merchant = Merchant.last

        expect(betty_merchant.status).to eq('disabled')

        within "#disabled_merchants" do 
          expect(page).to have_content("Betty Draper")
        end
      end
    end
  end
end