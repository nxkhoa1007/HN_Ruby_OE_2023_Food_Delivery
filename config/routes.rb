require 'sidekiq/web'
Rails.application.routes.draw do
  namespace :admin do
    scope "(:locale)", locale: /en|vi/ do
      root "home#index"
      resources :products
      resources :orders, only: %i(index edit update)
      resources :notifications, only: %i(index update) do
        collection do
          put "read_all", to: "notifications#read_all"
        end
      end
      authenticate :user, lambda{|u| u.role.to_sym == :admin } do
        mount Sidekiq::Web => "/jobs"
      end
    end
  end
  scope "(:locale)", locale: /en|vi/ do
    root "home#index"
    devise_for :users, controllers:
      { registrations: "users/registrations",
        confirmations: "users/confirmations",
        sessions: "users/sessions" }
    devise_scope :user do
      put "users/update_profile" => "users/registrations#update_info"
      get "users/change_password" => "users/registrations#change"
      put "users/change_password" => "users/registrations#update_password"
    end
    get "cart", to:"cart#show"
    resources :cart do
      member do
        post :update_quantity, action: :update_quantity
      end
    end
    resource :user do
      get "account", to:"users#edit"
      get "address", to:"user_infos#index"
    end
    resources :user_infos, except: %i(index show) do
      member do
        post :set_default, action: :set_default
      end
    end
    post "add_to_cart/:id", to: "cart#create", as: "add_to_cart"
    delete "cart_destroy/:id", to: "cart#destroy", as: "cart_destroy"
    delete "cart_destroy_all", to: "cart#destroy_all"
    resources :orders, only: %i(index update) do
      collection do
        get :select_info, action: :select_info
        post :update_info, action: :update_info
      end
    end
    get "checkout", to:"orders#new"
    post "checkout", to:"orders#create"
    resources :ratings, only: %i(new create)
    resources :categories do
      resources :products, only: %i(show)
    end
    resources :products, only: %i(index)
    post "search/suggestions", to: "products#suggestions", as: "search_suggestions"
    mount ActionCable.server => "/cable"
  end
end
