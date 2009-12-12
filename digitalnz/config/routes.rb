ActionController::Routing::Routes.draw do |map|
  map.resources :facet_fields

  map.resources :calais_entries

  map.resources :calais_child_words

  map.resources :calais_parent_words


  map.resources :calais_words

  map.resources :calais_submissions

  map.resources :phrase_frequencies

  map.resources :filtered_types

  map.resources :filter_types

  map.resources :phrases

  map.resources :centroids

  map.resources :submissions

  map.resources :extents

  map.resources :record_dates

  map.resources :cached_geo_searches

  map.resources :placenames

  map.resources :relations

  map.resources :formats

  map.resources :categories

  map.resources :rights

  map.resources :identifiers

  map.resources :coverages

  map.resources :subjects

  map.resources :tipes

  map.resources :natlib_metadatas, :member => { :map => :get },
                :collection => {:geoparsed, :get}
                
map.purchase 'geoparsed/addresses', :controller => 'natlib_metadatas', :action => 'addresses'
map.purchase 'geoparsed/address/:name', :controller => 'natlib_metadatas', :action => 'address'
map.purchase 'geoparsed/coverage/:name', :controller => 'natlib_metadatas', :action => 'coverage'
map.purchase 'geoparsed/coverages', :controller => 'natlib_metadatas', :action => 'coverages'

map.purchase 'geoparsed/metadata/:property_plural', :controller => 'natlib_metadatas', :action => 'generic_properties'
map.purchase 'geoparsed/metadata/:property_single/:name', :controller => 'natlib_metadatas', :action => 'generic_property'

map.purchase 'geoparsed/:order', :controller => 'natlib_metadatas', :action => 'geoparsed'

#Search URL - keep it short
map.purchase 'search/:q', :controller => 'archive_searches', :action => 'search', :id => 'q'

#Use 'collection' for methods that operate on the whole of the collection, in this case
#a search of the digital nz api
  map.resources :archive_searches, :collection => { :search => :post, :search => :get}

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
  # map.root :controller => "welcome"
  
  map.root :controller => "archive_searches"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
