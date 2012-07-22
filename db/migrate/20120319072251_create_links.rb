class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :name   , :default => '369hi'
      t.string :url  , :default => 'http://www.369hi.com/'
      t.string :picurl
      t.integer :paixu  , :default => 99
      t.integer :status  , :default => 1

      t.timestamps
    end
  end
end
