class CreateTiebaPosts < ActiveRecord::Migration
  def change
    create_table :tieba_posts do |t|
      t.integer :page_url_id
      t.text :content
      t.datetime :post_at
      t.integer :level
      t.integer :my_level
    end

    add_index :tieba_posts, :page_url_id
  end
end
