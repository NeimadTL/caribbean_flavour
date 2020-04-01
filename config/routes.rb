Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "customised_registrations" }
  root to: 'welcome#index'
  namespace :admin do
    resources :products
  end

  namespace :partner do
    resources :shops, only: [:index, :create, :show] do
      collection do
        get 'farming'
        get 'fishing'
      end

    end
  end
end
