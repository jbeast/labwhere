Rails.application.routes.draw do

  concern :change_status do
    patch 'activate', on: :member
    patch 'deactivate', on: :member
  end

  concern :auditable do
    scope_module do
      resources :audits, only: [:index]
    end
  end

  resources :location_types do
    scope_module do
      resources :locations, only: [:index]
    end

    concerns :auditable
  end

  resources :locations do 
    resources :labwares, only: [:index]
    resources :prints, only: [:new, :create]

    concerns :change_status
    concerns :auditable

  end

  resources :labwares, only: [:index, :show] do
    resources :histories, only: [:index]
  end

  resources :scans, only: [:new, :create]

  resources :searches, only: [:new, :create, :show]

  resources :users do
    concerns :auditable
    concerns :change_status
  end

  resources :teams

  resources :printers
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'scans#new'

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
