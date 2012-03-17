# encoding: utf-8
class CreateFuns < ActiveRecord::Migration
  def change
    create_table :funs do |t|
      t.string :title  , :null =>false, :default => '笑话'
      t.text :body     , :null =>false
      t.integer :click_time , :null =>false, :default => 1008
      t.string :from_url
      t.integer :category_id , :null =>false, :default => 0
      t.integer :user_id, :null =>false, :default => 0

      t.timestamps
    end
  end
end
