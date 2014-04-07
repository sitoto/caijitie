#DynamicSitemaps::Sitemap.draw do
  
  # default per_page is 50.000 which is the specified maximum.
  # per_page 10

#  url root_url, :last_mod => DateTime.now, :change_freq => 'daily', :priority => 1



  #autogenerate :posts, :last_mod => :published_at, :change_freq => 'weekly', :priority => 0.8
  #autogenerate :funs, :last_mod => :updated_at, :change_freq => 'weekly', :priority => 0.8
  #new_page!
  
  #Post.all.each do |post|
  #  url post_url(post), :last_mod => post.published_at, :change_freq => 'weekly', :priority => 0.8
  #end

  #autogenerate :post, :last_mod => :published_at, :change_freq => 'weekly', :priority => 0.8
  
  # autogenerate  :products, :categories,
  #               :last_mod => :updated_at,
  #               :change_freq => 'monthly',
  #               :priority => 0.8
                
  # new_page!
  
  # autogenerate  :users,
  #               :last_mod => :updated_at,
  #               :change_freq => lambda { |user| user.very_active? ? 'weekly' : 'monthly' },
  #               :priority => 0.5
  
#end
