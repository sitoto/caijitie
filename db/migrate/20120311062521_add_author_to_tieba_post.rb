class AddAuthorToTiebaPost < ActiveRecord::Migration
  def change
    add_column :tieba_posts, :author, :string
  end
end
