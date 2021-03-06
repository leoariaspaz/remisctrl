Remisctrl::Application.routes.draw do
  controller :logs_estado do
    get ':model_name/:id/page/:page' => :index
  end

  resources :cuentas do
    member do
      get 'getmovilbyagencia' => 'cuentas#getmovilbyagencia'
      get 'owner' => 'cuentas#owner'
    end
  end

  resources :configuraciones, only: [:edit, :update]

  controller :movimientos do
    get 'consultar'
    get 'consultar_agrupado'
  end
  resources :movimientos
  
  resources :transacciones

  get "configuracion/index"
  resources :usuarios
  patch 'usuarios/:id/reset_password' => 'usuarios#reset_password'

  get 'moviles/print', to: 'moviles#print_all'
  resources :moviles do
    member do
      get 'print_documentos', to: 'documentos#print'
      get 'print'
      get 'getchoferbyagencia/:agencia_id' => 'moviles#getchoferbyagencia'
    end
    resources :documentos, except: [:index, :edit, :update]
  end

  resources :propietarios do
    member do
      get 'print_documentos', to: 'documentos#print', format: :pdf
      get 'print'
    end
    resources :documentos, except: [:index, :edit, :update]
  end
  get 'propietarios/detail_select/:id' => 'propietarios#detail_select'

  resources :choferes do
    member do
      get 'print_documentos', to: 'documentos#print', format: :pdf
      get 'print'
    end
    resources :documentos, except: [:index, :edit, :update]
  end
  get 'choferes/detail_select/:id' => 'choferes#detail_select'

  resources :rellenos
  get 'rellenos/new/:tipo_relleno_id' => 'rellenos#new'

  resources :tipos_relleno
  
  controller :sessions do
  	get 'login' => :new
  	post 'login' => :create
  	delete 'logout' => :destroy
  end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'moviles#index'

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
