Rails.application.routes.draw do
  root to: "home#index"

  get "/dashboard", to: "users#show"
  get "/register", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  resources :users, only: [:create]
  resources :activate, only: [:show]

  namespace :api do
    namespace :v1 do
      resources :games, only: [:show, :create], module: :games do
        resources :shots, only: [:create]
        resources :ships, only: [:create]
      end
    end
  end
end
