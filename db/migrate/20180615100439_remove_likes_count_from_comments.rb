class RemoveLikesCountFromComments < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :likes_count
  end
end
