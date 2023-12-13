Rails.application.routes.draw do
  namespace :admin do
    scope "(:locale)", locale: /en|vi/ do
      root "home#index"
      resources :products
    end
  end
  scope "(:locale)", locale: /en|vi/ do
    root "home#index"
    get "signup", to: "users#new"
    post "signup", to: "users#create"
    resources :account_activations, only: :edit
    get 'login', to:"sessions#new"
    post 'login', to:"sessions#create"
    get 'logout', to:"sessions#destroy"
  end
end
