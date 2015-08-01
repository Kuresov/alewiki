Rails.application.routes.draw do

  resources :charges, only: [:create]
  get 'charges/downgrade'

  resources :wikis
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  get 'welcome/about'
  root to: 'welcome#index'
end
