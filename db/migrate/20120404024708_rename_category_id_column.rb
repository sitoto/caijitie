class RenameCategoryIdColumn < ActiveRecord::Migration
  def up
    rename_column :funs, :category_id, :type_id
  end

  def down
    rename_column :funs, :type_id, :category_id
  end
end
