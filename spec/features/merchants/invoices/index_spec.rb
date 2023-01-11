require 'rails_helper'

RSpec.describe 'The merchant invoices index page', type: :feature do
  describe 'as a merchant' do
    describe 'when I visit my merchant invoices index' do
      let(:merchant_1) { create(:merchant_with_invoices) }
      let(:merchant_2) { create(:merchant_with_invoices) }

      describe 'github partial' do
        it 'displays the repo info' do
          results = Poro::GithubDecorator.new(GithubRepo.new)
          visit merchant_invoices_path(merchant_1)

          expect(page).to have_content "Repo Name: little-esty-shop"
          expect(page).to have_content "User Names: Tscasady, pkseverance, Kerynn, pitzelalex"
          expect(page).to have_content "#{results.commits}"
          expect(page).to have_content "#{results.pull_requests}"
        end
      end
      
      it 'shows all of the invoices that include at least one of my merchant items and shows their id' do
        visit merchant_invoices_path(merchant_1)

        merchant_1.invoices.each do |invoice|
          
          expect(page).to have_content("Invoice ##{invoice.id}")
        end
        merchant_2.invoices.each do |invoice|
          expect(page).not_to have_content("Invoice ##{invoice.id}")
        end

        visit merchant_invoices_path(merchant_2)

        merchant_1.invoices.each do |invoice|
          expect(page).not_to have_content("Invoice ##{invoice.id}")
        end
        merchant_2.invoices.each do |invoice|
          expect(page).to have_content("Invoice ##{invoice.id}")
        end
      end

      it "has a link from each id to the corresponding merchant invoice page" do
        visit merchant_invoices_path(merchant_1)

        merchant_1.invoices.each do |invoice|
          expect(page).to have_link "#{invoice.id}", href: merchant_invoice_path(merchant_1, invoice)
        end
      end
    end
  end
end
