Rails.application.routes.draw do

  resources :charges, only: [:create]
  get 'charges/downgrade'

  resources :wikis do

    collection do
      get :collab
    end

    member do
      post :add_collaborator
      delete :leave_collaboration
    end
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  get 'welcome/about'

  root to: 'welcome#index'
end
