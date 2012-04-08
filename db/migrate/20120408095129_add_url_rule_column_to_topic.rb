class AddUrlRuleColumnToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :rule, :integer
    Topic.update_all("rule = section_id")
  end
end
