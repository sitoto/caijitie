class CreatePageUrls < ActiveRecord::Migration
  def change
    create_table :page_urls do |t|
      t.string :topic_id
      t.integer :num
      t.string :url
      t.integer :status, :null => false, :default => 0
      t.integer :count,  :null => false, :default => 0

      t.timestamps
    end
	add_index :page_urls, :topic_id
	add_index :page_urls, :url ,:unique => true
  end
end
