Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  root "games#index"

  resources :chits, only: [:create] # goes to index?
  resource :game, only: [:index] do
    collection do
      post 'reset'
    end
  end
end
