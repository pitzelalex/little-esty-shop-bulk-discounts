require 'rails_helper'

RSpec.describe 'The merchant bulk discounts show page', type: :feature do
  describe 'as a merchant' do
    let!(:merchant_1) { create(:merchant) }
    let!(:bd_1) { create(:bulk_discount, threshold: 5, discount: 0.90, merchant: merchant_1) }

    describe 'when I visit my merchant bulk discounts show page' do
      it 'displays the quantity threshold and percentage discount' do
        visit merchant_bulk_discount_path(merchant_1, bd_1)

        expect(page).to have_content("Item Threshold: #{bd_1.threshold}")
        expect(page).to have_content("Discount Percentage: #{bd_1.discount_percentage}")
      end

      it 'has a link to edit discount which takes me to edit discount page' do
        visit merchant_bulk_discount_path(merchant_1, bd_1)

        expect(page).to have_link 'Edit Discount', href: edit_merchant_bulk_discount_path(merchant_1, bd_1)

        click_link 'Edit Discount'

        expect(current_path).to eq(edit_merchant_bulk_discount_path(merchant_1, bd_1))
      end
    end
  end
end
