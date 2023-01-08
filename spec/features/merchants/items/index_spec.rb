require 'rails_helper'

RSpec.describe 'The merchant items index page', type: :feature do

  let!(:merchant_1) { create(:merchant_with_items) }
  let!(:merchant_2) { create(:merchant_with_items) }
  let!(:item_9) { create(:item, :enabled, merchant: merchant_2) }

  describe 'when a user visits a merchants items index page' do
    it 'displays all the names of a merchants items' do
      visit merchant_items_path(merchant_1)

      expect(page).to have_content "Item_1"
      expect(page).to have_content "Item_2"
      expect(page).to have_content "Item_3"
      expect(page).to have_content "Item_4"
      expect(page).to_not have_content "Item_5"

      visit merchant_items_path(merchant_2)

      expect(page).to_not have_content "Item_1"
      expect(page).to_not have_content "Item_2"
      expect(page).to_not have_content "Item_3"
      expect(page).to_not have_content "Item_4"
      expect(page).to have_content "Item_5"
    end
    
    it 'each name is a link to the item show page' do
      visit merchant_items_path(merchant_1)

      merchant_1.items.each do |item|
        expect(page).to have_link item.name, href: merchant_item_path(merchant_1, item)
      end
    end

    describe 'Enabling and Disabling items' do
      it 'has a button to disable or enable each item' do
        item_1 = merchant_2.items.first
        enabled_item = merchant_2.items.last
        visit merchant_items_path(merchant_2)

        within "#item_#{item_1.id}" do
          expect(page).to have_button "Enable"
        end

        within "#item_#{enabled_item.id}" do
          expect(page).to have_button "Disable"
        end
      end

      it 'can change an items status and return to the index page' do
        item_1 = merchant_1.items.first
        visit merchant_items_path(merchant_1)

        within("#item_#{item_1.id}") do
          click_button "Enable"
        end

        expect(current_path).to eq merchant_items_path(merchant_1)
        item_1.reload

        within "#item_#{item_1.id}" do
          expect(page).to have_button "Disable"
        end

        expect(item_1.status).to eq "enabled"
      end
    end

    describe 'Enabled / Disabled item sections' do
      it 'displays enabled items in the enabled items section' do
        visit merchant_items_path(merchant_2)

        expect(page).to have_content "Enabled Items"

        within("#enabled_items") do
          expect(page).to have_content "#{item_9.name}"
          expect(page).to_not have_content "Item_1"
        end
      end

      it 'displays disabled items in the disabled items section' do
        item = merchant_2.items.first
        visit merchant_items_path(merchant_2)

        within("#disabled_items") do
          expect(page).to have_content "#{item.name}"
          expect(page).to_not have_content "Item_9"
        end
      end
    end

    describe 'New Items' do
      it 'has a link to create a new item' do
        visit merchant_items_path(merchant_1)
        
        expect(page).to have_link "Create Item"

        click_link "Create Item"

        expect(current_path).to eq new_merchant_item_path(merchant_1)
      end
    end

    describe 'Popular Items' do
      it 'displays the name of the top 5 items with links to the item show page' do

        item_1 = create(:item_with_successful_transaction, number_of_invoices: 5, merchant: merchant_1)
        item_2 = create(:item_with_successful_transaction, number_of_invoices: 1, merchant: merchant_1)
        item_3 = create(:item_with_successful_transaction, number_of_invoices: 3, merchant: merchant_1)
        item_4 = create(:item_with_successful_transaction, number_of_invoices: 6, merchant: merchant_1)
        item_5 = create(:item_with_successful_transaction, number_of_invoices: 2, merchant: merchant_1)
        item_6 = create(:item_with_successful_transaction, number_of_invoices: 4, merchant: merchant_1)
        item_7 = create(:item_with_unsuccessful_transaction, number_of_invoices: 11, merchant: merchant_1)
        item_8 = create(:item_with_successful_transaction, number_of_invoices: 4, merchant: merchant_2)

        visit merchant_items_path(merchant_1)

        within("#top_items") do
          expect(page).to have_content "1. #{item_4.name}"
          expect(page).to have_link "#{item_4.name}"
          expect(page).to have_content "5. #{item_5.name}"
          expect(page).to have_link "#{item_5.name}"
        end
      end

      it 'displays the total revenue generated for each item in order from most to least' do

        item_1 = create(:item_with_successful_transaction, number_of_invoices: 5, merchant: merchant_1)
        item_2 = create(:item_with_successful_transaction, number_of_invoices: 1, merchant: merchant_1)
        item_3 = create(:item_with_successful_transaction, number_of_invoices: 3, merchant: merchant_1)
        item_4 = create(:item_with_successful_transaction, number_of_invoices: 6, merchant: merchant_1)
        item_5 = create(:item_with_successful_transaction, number_of_invoices: 2, merchant: merchant_1)
        item_6 = create(:item_with_successful_transaction, number_of_invoices: 4, merchant: merchant_1)
        item_7 = create(:item_with_unsuccessful_transaction, number_of_invoices: 11, merchant: merchant_1)
        item_8 = create(:item_with_successful_transaction, number_of_invoices: 4, merchant: merchant_2)

        visit merchant_items_path(merchant_1)
        #TODO:orderly didn't like/couldn't find expectations with names.
        within("#top_items") do
          expect("Total Revenue: 300000").to appear_before "Total Revenue: 200000"
          expect("Total Revenue: 200000").to appear_before "Total Revenue: 100000"
        end
      end
    end
  end
end