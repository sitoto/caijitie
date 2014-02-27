require 'not_preferred_host'
Caijitie::Application.routes.draw do



  get "pv/index"

  # Rewrite non-preferred hosts in production
  constraints(NotPreferredHost) do
    match '/:path' => redirect { |params| "http://#{NotPreferredHost::PREFERRED_HOST}/#{params[:path]}" }
  end

  # Root
  root :to => 'pages#home'

  # Blog
  match '/posts.:format' => 'posts#index'


  resources :posts, :only => [:show]
  resources :tags, :only => [:index, :show]

  match '/hot' => 'hot#index', :as => 'hot'
  match '/class' => 'class#index', :as => 'class'

  # Static pages
  match '/about' => 'pages#about', :as => 'about'
  match '/contact' => 'pages#contact', :as => 'contact'


  #search
  match "/search" => "search#index", :as => :search
  match "/category/:name" => "category#show", :constraints => {:name => /.*/}, :as => :category
  match "/author/:name" => "author#show" , :constraints => {:name => /.*/}, :as => :author

  #get "/download/tianya"
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
  resources :posts do
    get 'page/:page', :action => :index, :on => :collection
  end

  match '/blog' => 'posts#index', :as => 'blog'


  #topic =》 post-page(page_url)
  resources :p do
    put :renew, :on => :member
    get :top, :on => :member

    resources :pu do
      get ':page', :action => :index, :on => :collection
    end
    get ':page', :action => :show, :on => :member
  end

  #show one topic
  match '/p' => 'p#index' , :as => 'all'
  match '/p/:id' => 'p#show', :as => 'p'
  match '/funs' => 'funs#index', :as => 'funs'
  match '/funs/:id' => 'funs#show'

  #caiji list
  match '/tb' => 'tb#index', :as => 'tb'
  match '/tysq' => 'tysq#index', :as => 'tysq'
  match '/dbht' => 'dbht#index', :as => 'dbht'
  match '/recent' => 'recent#index', :as => 'recent'
  match '/active' => 'active#index', :as => 'active'
  match '/easy' => 'easy_cai#index', :as => 'easy'

  #easy_cai
    put "easy_cai/index"
    put "easy_cai/show"
    put "easy_cai/member"

  # Admin
  namespace :admin do
    root :to => 'posts#index'
    resources :posts, :only => [:show, :new, :create, :update, :edit, :destroy, :index]
    resources :tags, :only => [:new, :create, :update, :edit, :destroy, :index]
    resources :reports
    resources :easy_cais
    resources :topics
    get "topic_list/index"
    get "topic_list/tieba"
    get "topic_list/tianya"
    get "topic_list/douban"
  end

  match 'sitemap.xml' => 'sitemaps#sitemap'

 # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
