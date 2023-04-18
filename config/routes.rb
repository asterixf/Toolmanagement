Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :tools, only: [:index, :new, :create, :show, :edit, :update] do
    resources :wash_orders, only: [:new, :create]
  end

  resources :wash_orders, only: [:show]

  get 'dashboard', to: 'pages#dashboard'
end
