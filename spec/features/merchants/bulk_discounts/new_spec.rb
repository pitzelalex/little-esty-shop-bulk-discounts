require 'rails_helper'

RSpec.describe 'The merchant bulk discounts index page', type: :feature do
  let!(:merchant_1) { create(:merchant) }

  it 'has a form that creates a new bulk discount for the merchant' do
    visit new_merchant_bulk_discount_path(merchant_1)

    expect(page).to have_field('bulk_discount[threshold]')
    expect(page).to have_field('bulk_discount[discount]')
  end

  it 'when I click create bulk discount it creates a new discount
    and sends me back to my merchants bulk discount index page where I see that discount' do
    visit new_merchant_bulk_discount_path(merchant_1)

    fill_in 'bulk_discount[threshold]', with: '10'
    fill_in 'bulk_discount[discount]', with: '20'

    click_button 'Create Bulk discount'

    expect(current_path).to eq(merchant_bulk_discounts_path(merchant_1))

    expect(page).to have_content('10')
    expect(page).to have_content('20%')
  end

  it 'when I click create, it will not let me enter invalid data' do
    visit new_merchant_bulk_discount_path(merchant_1)

    fill_in 'bulk_discount[threshold]', with: 'ten'
    fill_in 'bulk_discount[discount]', with: '200'

    click_button 'Create Bulk discount'

    expect(current_path).to eq(new_merchant_bulk_discount_path(merchant_1))
    expect(page).to have_content('Threshold is not a number and Discount must be a number between 0 and 100')
  end
end
