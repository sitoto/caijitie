class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :name   , :default => 'lehazi'
      t.string :url  , :default => 'http://www.lehazi.com/'
      t.string :picurl
      t.integer :paixu  , :default => 99
      t.integer :status  , :default => 1

      t.timestamps
    end
  end
end
