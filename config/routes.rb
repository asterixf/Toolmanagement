Rails.application.routes.draw do
  devise_for :users, :path_prefix => 'd'

  resources :users, only: [:index, :show, :edit, :update]
  root to: "pages#home"

  get 'dashboard', to: 'pages#dashboard'
  get 'dashboard', to: 'pages#washorders'
  get 'dashboard', to: 'pages#damagedtools'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :tools, only: [:index, :new, :create, :show, :edit, :update] do
    resources :cavities, only: [:new, :create]
    resources :production_orders, only: [:new, :create]
    resources :blockages, only: [:new, :create]
    resources :wash_orders, only: [:new, :create]
  end

  resources :production_orders, only: [:edit, :update]

  resources :cavities, only: [:edit, :update]

  resources :blockages, only: [:index, :edit]

  resources :wash_orders, only: [:index, :show, :edit, :update]

end
