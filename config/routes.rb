Rails.application.routes.draw do
  devise_for :users, :path_prefix => 'd'

  resources :users, only: [:index, :show, :edit, :update, :new, :create]
  root to: "pages#home"

  get 'tools/:id/blockages_history', to: 'tools#blockages_history'
  get 'tools/production', to: 'tools#production'
  get 'blockages/active', to: 'blockages#active'
  # #Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :tools, only: [:index, :new, :create, :show, :edit, :update] do
    resources :cavities, only: [:new, :create]
    resources :production_orders, only: [:new, :create]
    resources :blockages, only: [:new, :create]
    resources :wash_orders, only: [:new, :create]
    resources :damage_reports, only: [:new, :create]
    get 'blockages_history', to: 'tools#blockages_history'
  end

  resources :production_orders, only: [:edit, :update]

  resources :cavities, only: [:edit, :update, :show, :destroy]

  resources :wash_orders, only: [:index, :show, :edit, :update]

  resources :damage_reports, only: [:index, :show, :edit, :update]

  resources :blockages, only: [:index, :show, :edit, :update]

end
