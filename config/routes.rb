Rails.application.routes.draw do
  resources :categories

  resources :permissions

  root 'static_pages#home'
  get 'home'    => 'static_pages#home'
  get 'welcome' => 'static_pages#welcome'
  get 'about'   => 'static_pages#about'
  get 'help'    => 'static_pages#help'
  get 'version/1.1' => 'static_pages#v1_1'
  get 'version/1.2' => 'static_pages#v1_2'

  get 'signin'  => 'sessions#new'
  get 'signout' => 'sessions#destroy'
  resources :sessions, only: [:create, :destroy]

  get 'monitor/dashboard' => 'monitor#dashboard'
  get 'monitor' => 'monitor#dashboard'

  get 'admin/dashboard' => 'admin#dashboard'
  get 'admin' => 'admin#dashboard'

  get 'archive' => 'reservations#archive'

  resources :reservations do
    collection do
      get 'archive'
    end

    member do
      get 'approve'
      post 'deny'
      get 'checkout'
      post 'checkout_update'
      get 'checkin'
      post 'checkin_update'
    end
  end
  resources :equipment do
    member do
      get 'history'
    end

    resources :sub_items
  end
  resources :users do
    member do
      get 'password'
    end

    collection do
      get 'monitors'
      get 'admins'
    end
  end
  resources :reservation_equipment

  get 'search' => 'search#index', as: :search

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
