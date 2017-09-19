Rails.application.routes.draw do
  resources :prosumers
  resources :building_types
  resources :intervals
  resources :clusters
  resources :clusterings
  resources :prosumer_categories
  resources :connection_types
  devise_for :users
  root 'pages#home'
  get 'pages/home'
  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
