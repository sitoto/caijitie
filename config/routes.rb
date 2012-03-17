require 'not_preferred_host'
Caijitie::Application.routes.draw do



  # Rewrite non-preferred hosts in production
  constraints(NotPreferredHost) do
    match '/:path' => redirect { |params| "http://#{NotPreferredHost::PREFERRED_HOST}/#{params[:path]}" }
  end

  # Root
  root :to => 'pages#home'

  # Blog
  match '/posts.:format' => 'posts#index'
  match '/blog' => 'posts#index', :as => 'blog'

  resources :posts, :only => [:show]
  resources :tags, :only => [:index, :show]


  # Static pages
  match '/about' => 'pages#about', :as => 'about'
  match '/contact' => 'pages#contact', :as => 'contact'

  #search
  match "/search" => "search#index", :as => :search
  match "/category/:name" => "category#show", :constraints => {:name => /.*/}, :as => :category
  match "/author/:name" => "author#show" , :constraints => {:name => /.*/}, :as => :author
  match "/download/:id" => "download#show" , :constraints => {:name => /\d+/}, :as => :download

  #page-list 's page'
  resources :tb do
    get 'page/:page', :action => :index, :on => :collection
  end
  resources :tysq do
    get 'page/:page', :action => :index, :on => :collection
  end
  resources :dbht do
    get 'page/:page', :action => :index, :on => :collection
  end
  resources :recent do
    get 'page/:page', :action => :index, :on => :collection
  end
  resources :active do
    get 'page/:page', :action => :index, :on => :collection
  end
  resources :funs do
    get 'page/:page', :action => :index, :on => :collection
  end
  resources :funs,  :only => [:show, :index]

  #topic =》 post-page(page_url)
  resources :p do
    put :renew, :on => :member
     resources :pu do
      get ':page', :action => :index, :on => :collection
     end
  end
  #show one topic
  match '/p' => 'p#index' , :as => 'all'
  match '/p/:id' => 'p#show', :as => 'p'

  #caiji list
  match '/tb' => 'tb#index', :as => 'tb'
  match '/tysq' => 'tysq#index', :as => 'tysq'
  match '/dbht' => 'dbht#index', :as => 'dbht'
  match '/recent' => 'recent#index', :as => 'recent'
  match '/active' => 'active#index', :as => 'active'
  # Admin
  namespace :admin do
    root :to => 'admin#index'
    resources :posts, :only => [:show, :new, :create, :update, :edit, :destroy, :index]
    resources :tags, :only => [:new, :create, :update, :edit, :destroy, :index]
    resources :topics
  end

  match 'sitemap.xml' => 'sitemaps#sitemap'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
