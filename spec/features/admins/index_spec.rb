require 'rails_helper'

RSpec.describe 'Admin Dashboard', type: :feature do 
  describe 'when the user visits the admin dashboard' do 
    it 'shows a header indicating the user is on the admin dashboard' do 
      visit admin_index_path 

      expect(page).to have_content("Admin Dashboard")
    end 
  end
end