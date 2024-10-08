# config/routes.rb
Rails.application.routes.draw do
  resources :insurance_products
  resources :asuransis
  resources :customers, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  resources :sessions, only: [:new, :create]

  # Define the root path
  root to: 'sessions#new' # Default root path for users not logged in

  # Define home path
  get 'home', to: 'home#index', as: :home

  # Define logout route
  get 'logout', to: 'sessions#destroy', as: :logout
end
