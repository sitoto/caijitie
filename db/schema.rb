# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120425073756) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "douban_posts", :force => true do |t|
    t.integer  "page_url_id"
    t.text     "content"
    t.datetime "post_at"
    t.integer  "level"
    t.integer  "my_level"
    t.string   "author"
  end

  add_index "douban_posts", ["page_url_id"], :name => "index_douban_posts_on_page_url_id"

  create_table "easy_cais", :force => true do |t|
    t.integer  "section_id"
    t.integer  "rule_id"
    t.string   "name"
    t.string   "url_address"
    t.integer  "paixu",       :default => 99
    t.integer  "status",      :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "funs", :force => true do |t|
    t.string   "title",      :default => "笑话", :null => false
    t.text     "body",                         :null => false
    t.integer  "click_time", :default => 1008, :null => false
    t.string   "from_url"
    t.integer  "type_id",    :default => 0,    :null => false
    t.integer  "user_id",    :default => 0,    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.string   "name",       :default => "lehazi"
    t.string   "url",        :default => "http://www.lehazi.com/"
    t.string   "picurl"
    t.integer  "paixu",      :default => 99
    t.integer  "status",     :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_urls", :force => true do |t|
    t.string   "topic_id"
    t.integer  "num"
    t.string   "url"
    t.integer  "status",     :default => 0, :null => false
    t.integer  "count",      :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_urls", ["topic_id"], :name => "index_page_urls_on_topic_id"
  add_index "page_urls", ["url"], :name => "index_page_urls_on_url", :unique => true

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink",    :limit => 128
    t.datetime "published_at"
    t.string   "short_url"
    t.string   "tweet_text"
    t.boolean  "homepageable",                :default => true
    t.text     "html_content"
  end

  add_index "posts", ["permalink"], :name => "posts_permalink_index", :unique => true

  create_table "reports", :force => true do |t|
    t.string   "name"
    t.integer  "topic_num"
    t.integer  "page_num"
    t.integer  "pagenot_num"
    t.integer  "tieba_num"
    t.integer  "douban_num"
    t.integer  "tianyabbs_num"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "post_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["post_id"], :name => "taggings_post_id_index"
  add_index "taggings", ["tag_id"], :name => "taggings_tag_id_index"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], :name => "tags_name_index", :unique => true

  create_table "temp", :primary_key => "mid", :force => true do |t|
    t.integer "maxid"
  end

  create_table "tianya_posts", :force => true do |t|
    t.integer  "page_url_id"
    t.text     "content"
    t.datetime "post_at"
    t.integer  "level"
    t.integer  "my_level"
    t.string   "author"
  end

  add_index "tianya_posts", ["page_url_id"], :name => "index_tianya_posts_on_page_url_id"

  create_table "tieba_posts", :force => true do |t|
    t.integer  "page_url_id"
    t.text     "content"
    t.datetime "post_at"
    t.integer  "level"
    t.integer  "my_level"
    t.string   "author"
  end

  add_index "tieba_posts", ["page_url_id"], :name => "index_tieba_posts_on_page_url_id"

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.string   "classname"
    t.string   "author"
    t.datetime "myfirsttime"
    t.datetime "myupdatetime"
    t.integer  "mypagenum",    :default => 1
    t.integer  "mypostnum"
    t.integer  "myshowtimes",  :default => 1
    t.integer  "mydowntimes",  :default => 0
    t.datetime "firsttime"
    t.integer  "showtimes",    :default => 1
    t.integer  "wordnum",      :default => 0
    t.string   "fromurl"
    t.string   "tags"
    t.integer  "section_id",   :default => 0
    t.integer  "status",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rule"
    t.string   "my_title"
    t.integer  "top",          :default => 0
  end

  add_index "topics", ["author"], :name => "index_topics_on_author", :length => {"author"=>191}
  add_index "topics", ["classname"], :name => "index_topics_on_classname", :length => {"classname"=>191}
  add_index "topics", ["fromurl"], :name => "index_topics_on_fromurl", :unique => true
  add_index "topics", ["mydowntimes"], :name => "index_topics_on_mydowntimes"
  add_index "topics", ["mypostnum"], :name => "index_topics_on_mypostnum"
  add_index "topics", ["myshowtimes"], :name => "index_topics_on_myshowtimes"
  add_index "topics", ["myupdatetime"], :name => "index_topics_on_myupdatetime"
  add_index "topics", ["section_id"], :name => "index_topics_on_section_id"
  add_index "topics", ["showtimes"], :name => "index_topics_on_showtimes"
  add_index "topics", ["tags"], :name => "index_topics_on_tags", :length => {"tags"=>191}
  add_index "topics", ["title"], :name => "index_topics_on_title", :length => {"title"=>191}

end
