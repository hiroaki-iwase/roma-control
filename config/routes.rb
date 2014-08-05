Gladiator::Application.routes.draw do
  # Storage
  get  "storage/index"

  # logs
  get "logs/index"
  get "logs/download"

  # routing
  get "routing/index"
  get "routing/download"

  # login
  root :to => "login#index"
  get  "login" => "login#index"
  get  "login/index"
  post "login/auth"
  get  "login/logout"

  # API
  get  "api/get_parameter"
  get  "api/get_parameter/:host/:port" => "api#get_parameter", :host => /.*/
  get  "api/get_routing_info"
  get  "api/get_value/:key" => "api#get_value"
  post "api/set_value"

  # cluster(Top Page)
  get  "cluster/index"
  post "cluster/create"
  post "cluster/destroy"
  get  "cluster/update"
  post "cluster/release"

  # stats/configurations 
  get "stat/index"
  get "stat/edit"
  put "stat/update"

  # 404 Error
  get  '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
  put  '*not_found' => 'application#routing_error'

  #resources :stat

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
