ActionController::Routing::Routes.draw do |map|
  map.resources :institucion_academicas

  map.resources :estudios

  ## Administracion de perfiles academicos ##
  map.resources :empleados
  map.connect 'empleado/formacion/:id', :controller => "empleados", :action => "formacion"
  map.connect 'empleado/new_formacion/:id', :controller => "empleados", :action => "new_formacion"
  map.connect 'empleado/destroy_formacion/:id', :controller => "empleados", :action => "destroy_formacion"
  map.connect 'empleado/show_formacion/:id', :controller => "empleados", :action => "show_formacion"
  map.connect 'empleado/edit_formacion/:id', :controller => "empleados", :action => "edit_formacion"
  

  map.resources :cuadrantes, :only => [:index, :new, :create, :edit, :show]


  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code',:controller=>'users',:action=>'activate'
  map.resources :users
  map.resource :session
  map.resource :admins


  #--- new users only from admin --
  map.connect 'users/:new_from_admin', :controller => 'users', :action => 'new_from_admin'
  map.connect 'users/:save', :controller => 'users', :action => 'save'

  #---- rutas globales ---
  map.admin "/admin/index", :controller=>'admin',:action=>'index'
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
