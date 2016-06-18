Rails.application.routes.draw do
  get 'hello_world', to: 'hello_world#index'
  root 'posts#index'

  get 'index', to: 'home#index', as: :index
  get 'about', to: 'home#about', as: :about
  get 'feed', to: 'home#feed', as: :feed

  resources :users, only: [:new, :create]
  resources :sessions, only: [:create, :destroy]
  get 'login', to: "sessions#new", as: :login
  post 'login', to: "sessions#create"
  delete 'logout', to: "sessions#destroy", as: :logout

  resources :categories, only: [:index, :create, :destroy]
  resources :posts
  resources :links, except: [:show]

  #match "*path", to: "home#four_oh_four", via: :all
end
