require 'not_preferred_host'
Caijitie::Application.routes.draw do

  get "pv/index"

  # Rewrite non-preferred hosts in production
  constraints(NotPreferredHost) do
    get '/:path' => redirect { |params| "http://#{NotPreferredHost::PREFERRED_HOST}/#{params[:path]}" }
  end

  # Root
  root :to => 'pages#home'

  # Blog
  get '/posts.:format' => 'posts#index'
  get '/blog' => 'posts#index', :as => 'blog'


  resources :posts, :only => [:show]
  resources :tags, :only => [:index, :show]

  get '/hot' => 'hot#index', :as => 'hot'
  get '/class' => 'class#index', :as => 'class'

  # Static pages
  get '/about' => 'pages#about', :as => 'about'
  get '/contact' => 'pages#contact', :as => 'contact'


  #search
  get "/search" => "search#index", :as => :search
  get "/category/:name" => "category#show", :constraints => {:name => /.*/}, :as => :category
  get "/author/:name" => "author#show" , :constraints => {:name => /.*/}, :as => :author

  #get "/download/tianya"
  get "/download/:id" => "download#show" , :constraints => {:name => /\d+/}, :as => :download


  #page-list 's page'
  resource :tb  do
    get 'page/:page', :action => :show#, :on => :collection
  end
  resource :tysq do
    get 'page/:page', :action => :show
  end
  resource :dbht do
    get 'page/:page', :action => :show
  end
  resource :recent do
    get 'page/:page', :action => :show#, :on => :collection
  end
  resource :active do
    get 'page/:page', :action => :show
  end
  resources :funs do
    get 'page/:page', :action => :index, :on => :collection
  end
  resources :posts do
    get 'page/:page', :action => :index, :on => :collection
  end

  

  #topic =》 post-page(page_url)
  resources :p do
    put :renew, :on => :member
    get :top, :on => :member

    resources :pu do
      get ':page', :action => :index, :on => :collection
    end
    get ':page', :action => :show, :on => :member
  end


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

  get 'sitemap.xml' => 'sitemaps#sitemap'

 # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
