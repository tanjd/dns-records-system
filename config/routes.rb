Rails.application.routes.draw do
  root "home#index"
  get "servers", to: "home#servers.html"
  namespace :api do
    namespace :v1 do
      resources :hosted_servers
      resources :servers
      resources :clusters
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
