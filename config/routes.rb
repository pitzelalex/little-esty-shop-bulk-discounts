Rails.application.routes.draw do
  resources :customers
  resources :merchants
  get '/merchants/:id/dashboard', to: "merchants#show"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
