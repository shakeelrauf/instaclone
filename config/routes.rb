Rails.application.routes.draw do

  mount ActionCable.server => '/cable'
  devise_for :users

  resources :posts do
    member do
      get :likes
      post :comment
    end
  end

  resources :users do
    member do
      get :follow
    end
  end

  resources :notifications, only: [ :index ]
  root 'posts#index'
end
