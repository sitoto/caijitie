require 'open-uri'
class DownloadController < ApplicationController
  caches_page :show
  def show
    @topic = Topic.find(params[:id])
  end

  def tianya
    pic_url = params[:url].to_s
    headers = {"Referer" => "http://www.tianya.cn/"}
    open(pic_url, headers)
  end

end
