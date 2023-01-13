require 'rails_helper'

RSpec.describe 'The merchant bulk discounts index page', type: :feature do
  describe 'as a merchant' do
    let!(:merchant_1) { create(:merchant) }
    let!(:merchant_2) { create(:merchant) }
    let!(:bd_1) { create(:bulk_discount, threshold: 5, discount: 0.90, merchant: merchant_1) }
    let!(:bd_2) { create(:bulk_discount, threshold: 10, discount: 0.80, merchant: merchant_1) }
    let!(:bd_3) { create(:bulk_discount, threshold: 20, discount: 0.70, merchant: merchant_1) }
    let!(:bd_4) { create(:bulk_discount, threshold: 30, discount: 0.60, merchant: merchant_2) }

    describe 'when I visit my merchant bulk discounts index' do
      it 'displays all of my bulk discounts' do
        visit merchant_bulk_discounts_path(merchant_1)
        # require 'pry'; binding.pry
        # save_and_open_page
        within '#discounts' do
          expect(page).to have_content('Item Threshold')
          expect(page).to have_content('Discount %')

          within "#discount-#{bd_1.id}" do
            expect(page).to have_content('5')
            expect(page).to have_content('10%')
          end

          within "#discount-#{bd_2.id}" do
            expect(page).to have_content('10')
            expect(page).to have_content('20%')
          end

          within "#discount-#{bd_3.id}" do
            expect(page).to have_content('20')
            expect(page).to have_content('30%')
          end
        end
      end
      it 'displays a link to each discounts show page'
    end
  end
end
