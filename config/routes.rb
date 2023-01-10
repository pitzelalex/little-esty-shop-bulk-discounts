Rails.application.routes.draw do
  resources :customers
  resources :merchants do
    resources :items, controller: "merchants/items"
    resources :invoices, only: [:index, :show], controller: 'merchants/invoices'
  end
  resources :invoice_items, only: :update

  get '/merchants/:id/dashboard', to: "merchants#show"

  resources :admin, only: [:index]

  namespace :admin do
    resources :merchants
    resources :invoices, only: [:index, :show, :update]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
