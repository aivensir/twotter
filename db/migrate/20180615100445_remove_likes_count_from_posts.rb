class RemoveLikesCountFromPosts < ActiveRecord::Migration[5.2]
  def change
    remove_column :comments, :likes_count
  end
end
