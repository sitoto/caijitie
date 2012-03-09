class PageUrl < ActiveRecord::Base
  belongs_to :topic
  has_many :tieba_posts

  paginates_per 1
end
