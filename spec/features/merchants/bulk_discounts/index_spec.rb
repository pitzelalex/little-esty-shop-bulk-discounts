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

        within '#discounts' do
          expect(page).to have_content('ID')
          expect(page).to have_content('Item Threshold')
          expect(page).to have_content('Discount %')

          within "#discount-#{bd_1.id}" do
            expect(page).to have_content(bd_1.id)
            expect(page).to have_content('5')
            expect(page).to have_content('10%')
          end

          within "#discount-#{bd_2.id}" do
            expect(page).to have_content(bd_2.id)
            expect(page).to have_content('10')
            expect(page).to have_content('20%')
          end

          within "#discount-#{bd_3.id}" do
            expect(page).to have_content(bd_3.id)
            expect(page).to have_content('20')
            expect(page).to have_content('30%')
          end
        end
      end

      it 'displays a link to each discounts show page' do
        visit merchant_bulk_discounts_path(merchant_1)

        within '#discounts' do
          within "#discount-#{bd_1.id}" do
            expect(page).to have_link "show", href: merchant_bulk_discount_path(merchant_1, bd_1)
          end

          within "#discount-#{bd_2.id}" do
            expect(page).to have_link 'show', href: merchant_bulk_discount_path(merchant_1, bd_2)
          end

          within "#discount-#{bd_3.id}" do
            expect(page).to have_link 'show', href: merchant_bulk_discount_path(merchant_1, bd_3)
          end
        end
      end

      it 'has a link to create a new discount' do
        visit merchant_bulk_discounts_path(merchant_1)

        expect(page).to have_link 'New Bulk Discount', href: new_merchant_bulk_discount_path(merchant_1)

        click_link 'New Bulk Discount'

        expect(current_path).to eq(new_merchant_bulk_discount_path(merchant_1))
      end

      it 'next to each discount it displays a link to delete it' do
        visit merchant_bulk_discounts_path(merchant_1)

        expect(page).to have_css("#discount-#{bd_1.id}")

        within "#discount-#{bd_1.id}" do
          expect(page).to have_link 'Delete', href: bulk_discount_path(bd_1, merchant_id: merchant_1)
          click_link 'Delete'
        end

        expect(current_path).to eq(merchant_bulk_discounts_path(merchant_1))

        expect(page).not_to have_css("#discount-#{bd_1.id}")
      end

      it 'lists the next 3 upcoming holidays' do
        holidays = JSON.parse((HTTParty.get('https://date.nager.at/api/v3/NextPublicHolidays/CA')).body, symbolize_names: true)

        visit merchant_bulk_discounts_path(merchant_1)

        within '#holidays' do
          expect(page).to have_content('Upcoming Holidays')
          expect(page).to have_content(holidays[0][:name])
          expect(page).to have_content(holidays[1][:name])
          expect(page).to have_content(holidays[2][:name])
        end
      end
    end
  end
end
