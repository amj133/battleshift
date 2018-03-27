Rails.application.routes.draw do
  root to: "home#index"

  get "/dashboard", to: "users#show"
  get "/register", to: "users#new"
  resources :users, only: [:create]
  resources :activate, only: [:show]

  namespace :api do
    namespace :v1 do
      resources :games, only: [:show, :create] do
        resources :shots, only: [:create]
        # post "/shots", to: "games/shots#create"
      end
    end
  end
end
