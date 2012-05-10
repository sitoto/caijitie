class Fun < ActiveRecord::Base

  def published?
    updated_at < Time.now
  end
  def previous
    self.class.where('id < ?', id).order('id DESC').first
  end

  def next
    self.class.where('id > ?', id).order('id ASC').first
  end
end
