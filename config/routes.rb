Rails.application.routes.draw do

  resources :charges, only: [:new, :create]
  get 'charges/downgrade'

  resources :wikis do

    collection do
      get :collab
    end

    member do
      post :add_collaborator
    end
  end

  devise_for :users

  get 'welcome/about'

  root to: 'welcome#index'
end
