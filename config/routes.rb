Rails.application.routes.draw do
  namespace :admin do
    scope "(:locale)", locale: /en|vi/ do
      root "home#index"
    end
  end
  scope "(:locale)", locale: /en|vi/ do
    root "home#index"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    resources :account_activations, only: :edit
  end
end
