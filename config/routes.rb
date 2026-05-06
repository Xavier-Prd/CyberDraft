Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # Amis
  resources :friendships, only: [ :create, :update, :destroy ]

  # Duels
  resources :duels, only: [ :index, :show, :create ] do
    member do
      patch :accept
      patch :decline
    end
  end

  # Draft (rounds + bids)
  resources :draft_rounds, only: [ :show ] do
    member do
      post :validate
    end
    resources :bids, only: [ :create ]
  end
  resources :bids, only: [ :update ]

  # Personnages
  resources :characters, only: [ :index, :show ]

  # Matchs
  resources :matches, only: [ :index, :show ]

  # Classement
  get "leaderboard", to: "leaderboard#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
