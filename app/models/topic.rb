#encoding: utf-8
class Topic < ActiveRecord::Base
  has_many :page_urls, :dependent => :delete_all
  has_many :tieba_posts, :through => :page_urls
  has_many :tianya_posts, :through => :page_urls

  has_one  :most_recent_page_url,
      :class_name => 'PageUrl',
      :order => 'num DESC'

  paginates_per 25

  def get_tieba_topic(url)
    t = TiebaTuoshuiJob.cai_tieba(url)
  end

  def get_tianya_topic(url)
    t, page_urls = TianyabbsTuoshuiJob.cai_tianyabbs_topic(url)
  end

  def get_douban_topic(url)
    t = DoubanhuatiTuoshuiJob.cai_doubanhuati_topic(url)
  end

end
