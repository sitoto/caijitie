class ApplicationController < ActionController::Base
  protect_from_forgery
    helper_method :is_iphone?
 rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  $id = 0
  private

  def record_not_found
    render :text => "404 Not Found", :status => 404
  end
  private

  def is_iphone?
    user_agent = request.env['HTTP_USER_AGENT']
    user_agent && user_agent[/iPhone/] && !user_agent[/iPad/] && !user_agent[/iPod/]
  end
end
