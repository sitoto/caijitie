class AddTopColumnToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :top, :integer    , :default => 0
    Topic.update_all("top = status")
  end
end
