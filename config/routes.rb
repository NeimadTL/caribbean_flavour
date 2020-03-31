Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "customised_registrations" }
  root to: 'welcome#index'
  namespace :admin do
    resources :products
  end
end
