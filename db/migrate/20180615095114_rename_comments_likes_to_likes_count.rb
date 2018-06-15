class RenameCommentsLikesToLikesCount < ActiveRecord::Migration[5.2]
  def change
    rename_column :comments, :likes, :likes_count
  end
end
