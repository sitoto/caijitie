#encoding: utf-8
class Topic < ActiveRecord::Base
  has_many :page_urls

  paginates_per 2

  def get_tieba_topic(url)
    t = TiebaTuoshuiJob.cai_tieba(url)
  end

  def get_tianya_topic(url)

  end

  def get_douban_topic(url)

  end

end
