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
    #
    #
    expire_action(:controller => 'pages', :action => 'home')
    expire_action(:controller => 'hot', :action => 'index')
    expire_action(:controller => 'class', :action => 'index')
    expire_action(:controller => 'tbs', :action => 'show')
    expire_action(:controller => 'tysqs', :action => 'show')
    expire_action(:controller => 'dbhts', :action => 'show')
    expire_action(:controller => 'recents', :action => 'show')
    expire_action(:controller => 'actives', :action => 'show')

    # Expire a fragment
    expire_fragment('all_available_topics')
  end
  def expire2_cache_for(topic)
    # Expire the index page now that we added a new topic
    expire_page(:controller => 'pages', :action => 'home')
    expire_page(:controller => 'hot', :action => 'index')
    expire_page(:controller => 'actives', :action => 'show')

    # Expire a fragment
    #expire_fragment('all_available_topics')
  end
end
