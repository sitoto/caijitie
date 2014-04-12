class TopicSweeper < ActionController::Caching::Sweeper
  observe Topic

  # If our sweeper detects that a Topic was created call this
  def after_create(topic)
    expire_cache_for(topic)
  end

  # If our sweeper detects that a Topic was updated call this
  def after_update(topic)
    expire2_cache_for(topic)
  end

  # If our sweeper detects that a Topic was deleted call this
  def after_destroy(topic)
    expire_cache_for(topic)
  end

  private
  def expire_cache_for(topic)
    # Expire the index page now that we added a new topic
    expire_page(:controller => 'pages', :action => 'home')
    expire_page(:controller => 'hot', :action => 'index')
    expire_page(:controller => 'class', :action => 'index')
    expire_page(:controller => 'tb', :action => 'index')
    expire_page(:controller => 'tysq', :action => 'index')
    expire_page(:controller => 'dbht', :action => 'index')
    expire_page(:controller => 'recent', :action => 'index')
    expire_page(:controller => 'active', :action => 'index')

    # Expire a fragment
    expire_fragment('all_available_topics')
  end
  def expire2_cache_for(topic)
    # Expire the index page now that we added a new topic
    expire_page(:controller => 'pages', :action => 'home')
    expire_page(:controller => 'hot', :action => 'index')
    expire_page(:controller => 'active', :action => 'index')

    # Expire a fragment
    #expire_fragment('all_available_topics')
  end
end