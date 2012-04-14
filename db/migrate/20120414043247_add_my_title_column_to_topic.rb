class AddMyTitleColumnToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :my_title, :string
    Topic.update_all("my_title = title")
  end
end
