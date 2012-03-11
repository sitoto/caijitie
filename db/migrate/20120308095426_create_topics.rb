class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.string :classname
      t.string :author

      t.datetime :myfirsttime
      t.datetime :myupdatetime , :null => false, :default => Time.now
      t.integer :mypagenum  , :default => 1
      t.integer :mypostnum   , :default => 1
      t.integer :myshowtimes    , :default => 1
      t.integer :mydowntimes    , :default => 0

      t.datetime :firsttime
      t.integer :showtimes    , :default => 1
      t.integer :wordnum    , :default => 0
      t.string :fromurl
      t.string :tags
      t.integer :section_id     , :default => 0
      t.integer :status     , :default => 0   # 楼主贴/讨论贴

      t.timestamps
    end
    add_index :topics, :classname
    add_index :topics, :author
    add_index :topics, :title
    add_index :topics, :section_id
    add_index :topics, :myupdatetime
    add_index :topics, :mypostnum
    add_index :topics, :mydowntimes
    add_index :topics, :myshowtimes
    add_index :topics, :showtimes

    add_index :topics, :fromurl, unique: true
    add_index :topics, :tags
    end

end
