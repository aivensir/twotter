class RenamePostsLikesToLikesCount < ActiveRecord::Migration[5.2]
  def change
    rename_column :posts, :likes, :likes_count
  end
end