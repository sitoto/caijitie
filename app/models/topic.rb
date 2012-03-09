class Topic < ActiveRecord::Base
  has_many :page_urls

  paginates_per 2
end
