class AddAuthTokenCreatedAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :auth_token_created_at, :datetime, null: false, default: Time.now
  end
end
