Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :messages
  resources :recommendations do
    post :send_messages, on: :member
    post :delete_messages, on: :member
  end
  resources :recommendation_types
  resources :cl_scenarios
  resources :scenarios do
    get :stderr, on: :member
  end
  resources :energy_programs
  resources :ecc_types
  resources :data_points
  resources :consumers
  resources :consumer_categories
  resources :communities
  resources :building_types
  resources :intervals
  resources :clusterings
  resources :connection_types
  resources :flexibilities
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'pages#home'
  get 'pages/home'
  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
