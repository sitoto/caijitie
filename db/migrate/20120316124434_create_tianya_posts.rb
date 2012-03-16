class CreateTianyaPosts < ActiveRecord::Migration
  def change
    create_table :tianya_posts do |t|
      t.integer :page_url_id
      t.text :content
      t.datetime :post_at
      t.integer :level
      t.integer :my_level
      t.string  :author

    end

    add_index :tianya_posts, :page_url_id
  end
end
