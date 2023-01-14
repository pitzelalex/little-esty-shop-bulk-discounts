require 'rails_helper'

RSpec.describe 'The merchant bulk discount edit page', type: :feature do
  let!(:merchant_1) { create(:merchant) }
  let!(:bd_1) { create(:bulk_discount, threshold: 5, discount: 0.90, merchant: merchant_1) }

  describe 'as a merchant' do
    describe 'when I visit my merchant bulk discount edit page' do
      it 'has a form that updates the discount details' do
        visit edit_merchant_bulk_discount_path(merchant_1, bd_1)

        expect(page).to have_field('bulk_discount[threshold]', with: '5')
        expect(page).to have_field('bulk_discount[discount]', with: '10')

        fill_in 'bulk_discount[threshold]', with: 10
        fill_in 'bulk_discount[discount]', with: 20

        click_button 'Update Bulk discount'

        expect(current_path).to eq(merchant_bulk_discount_path(merchant_1, bd_1))

        expect(page).to have_content('Item Threshold: 10')
        expect(page).to have_content('Discount Percentage: 20')

        visit edit_merchant_bulk_discount_path(merchant_1, bd_1)

        fill_in 'bulk_discount[threshold]', with: 'junk'
        fill_in 'bulk_discount[discount]', with: 500

        click_button 'Update Bulk discount'

        expect(current_path).to eq(edit_merchant_bulk_discount_path(merchant_1, bd_1))

        expect(page).to have_content('Threshold is not a number and Discount must be a number between 0 and 100')
      end
    end
  end
end
