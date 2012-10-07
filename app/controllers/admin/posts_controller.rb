class Admin::PostsController < AdminController
  before_filter :find_post, :only => [:show, :edit, :update, :destroy]

  def index
    @posts = Post.recent.page(params[:page])
  end

  def new
    @post = Post.new
  end

  def create
    expire_page(:controller => '/posts', :action => 'index')

    @post = Post.new(params[:post])
    if @post.save
      flash[:notice] = 'Successfully created post.'
      redirect_to [:admin, @post]
    else
      render 'new'
    end
  end

  def update
    if @post.update_attributes(params[:post])
    expire_page(:controller => '/posts', :action => 'show', :id => @post.permalink)

      flash[:notice] = 'Successfully updated post.'
      redirect_to [:admin, @post]
    else
      render 'edit'
    end
  end

  def destroy
    expire_cache_for()

    @post.destroy
    flash[:notice] = 'Successfully destroyed post.'
    redirect_to admin_posts_url
  end

  protected

  def find_post
    @post = Post.find_by_permalink(params[:id])
  end

  private
  def expire_cache_for()
    # Expire the index page now that we added a new topic
    expire_page(:controller => '/posts', :action => 'index')
    #expire_page(:controller => '/posts', :action => 'show')

    # Expire a fragment
    #expire_fragment('all_available_topics')
  end
end
