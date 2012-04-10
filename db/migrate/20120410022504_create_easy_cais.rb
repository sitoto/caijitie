class CreateEasyCais < ActiveRecord::Migration
  def change
    create_table :easy_cais do |t|
      t.integer :section_id
      t.integer :rule_id
      t.string :name
      t.string :url_address
      t.integer :paixu  , :default => 99
      t.integer :status  , :default => 1

      t.timestamps
    end
  end
end
