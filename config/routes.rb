Rails.application.routes.draw do
  resources :customers
  resources :merchants do
    resources :items, only: [:index], controller: "merchants/items"
  end
  get '/merchants/:id/dashboard', to: "merchants#show"
  namespace :admin do
    resources :merchants, only: [:index]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
