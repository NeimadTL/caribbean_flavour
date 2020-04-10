Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "customised_registrations" }
  root to: 'welcome#index'
  namespace :admin do
    resources :products
  end

  namespace :partner do
    resources :shops, only: [:index, :new, :create, :show, :edit, :update] do
      resources :stocks
    end
  end

  namespace :consumer do
    resources :shops, only: [:index, :show]
    resources :stocks, only:[] do
      resources :line_items
    end
    resources :carts
  end
end
