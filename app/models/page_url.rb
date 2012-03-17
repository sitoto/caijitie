class PageUrl < ActiveRecord::Base
  belongs_to :topic
  has_many :tieba_posts, :dependent => :delete_all
  has_many :tianya_posts, :dependent => :delete_all
  has_many :douban_posts, :dependent => :delete_all

  paginates_per 1
end
