class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :name
      t.integer :topic_num
      t.integer :page_num
      t.integer :pagenot_num
      t.integer :tieba_num
      t.integer :douban_num
      t.integer :tianyabbs_num
      t.text  :note

      t.timestamps
    end
  end
end
