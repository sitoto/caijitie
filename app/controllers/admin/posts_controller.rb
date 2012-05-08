class Admin::PostsController < AdminController
  before_filter :find_post, :only => [:show, :edit, :update, :destroy]

  def index
    @posts = Post.recent.page(params[:page])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      expire_cache_for()
      flash[:notice] = 'Successfully created post.'
      redirect_to [:admin, @post]
    else
      render 'new'
    end
  end

  def update
    if @post.update_attributes(params[:post])
      expire_cache_for()
      flash[:notice] = 'Successfully updated post.'
      redirect_to [:admin, @post]
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    expire_cache_for()
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
    expire_page(:controller => 'posts', :action => 'index')
    expire_page(:controller => 'posts', :action => 'show')
    expire_page(:controller => 'tags', :action => 'index')
    expire_page(:controller => 'tags', :action => 'show')

    # Expire a fragment
    expire_fragment('all_available_topics')
  end
end
