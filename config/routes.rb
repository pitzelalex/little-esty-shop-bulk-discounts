Rails.application.routes.draw do

  resources :merchants do
    resources :items, controller: "merchants/items"
    resources :invoices, only: [:index, :show], controller: 'merchants/invoices'
  end
  
  resources :invoice_items, only: :update

  get '/merchants/:id/dashboard', to: "merchants#show"

  resources :admin, only: [:index]

  namespace :admin do
    resources :merchants, except: [:destroy]
    resources :invoices, only: [:index, :show]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
