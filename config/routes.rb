Rails.application.routes.draw do
  namespace :admin do
    scope "(:locale)", locale: /en|vi/ do
      root "home#index"
    end
  end
  scope "(:locale)", locale: /en|vi/ do
    root "user_home#index"
  end
end
