require 'rails_helper'

RSpec.describe 'Admin Dashboard', type: :feature do 
  describe 'when the user visits the admin dashboard' do 
    it 'shows a header indicating the user is on the admin dashboard' do 
      visit admin_index_path 

      expect(page).to have_content("Admin Dashboard")
    end 

    it 'has a link to the admin merchants index page' do 
      visit admin_index_path 

      expect(page).to have_link "Admin Merchants Index"

      click_link("Admin Merchants Index")

      expect(current_path).to eq admin_merchants_path
    end

    xit 'has a link to the admin invoices index page' do 

    end 
  end
end