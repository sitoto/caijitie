class CreateDoubanPosts < ActiveRecord::Migration
  def change
    create_table :douban_posts do |t|
      t.integer :page_url_id
      t.text :content
      t.datetime :post_at
      t.integer :level
      t.integer :my_level
      t.string  :author

    end

    add_index :douban_posts, :page_url_id
  end
end
