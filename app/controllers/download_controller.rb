class DownloadController < ApplicationController
  caches_page :show
  def show
    @topic = Topic.find(params[:id])
  end

end
