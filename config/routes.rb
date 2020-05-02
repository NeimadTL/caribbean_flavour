Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "customised_registrations" }
  root to: 'welcome#index'
  namespace :admin do
    resources :products
  end

  namespace :partner do
    resources :shops, only: [:index, :new, :create, :show, :edit, :update] do
      resources :stocks, only: [:new, :create, :edit, :update, :destroy]
      resources :orders, only: [:index, :show, :edit, :update]
    end
  end

  namespace :consumer do
    resources :shops, only: [:index, :show]
    resources :carts, only: [] do
      resources :stocks, only: [] do
        resources :line_items, only: [:new, :create, :edit, :update, :destroy]
      end
    end
    resources :carts, only: [:show] do
      resources :shops, only: [] do
        resources :orders, only: [:new, :create]
      end
    end
    # :edit and :updates may need to be added below if we decide that a consumer
    # can update and order till the status passes from 'ordered' to 'packing'
    resources :orders, only: [:index, :show, :destroy]
  end
end
