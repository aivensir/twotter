class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :text
      t.integer :likes, default: 0
      t.belongs_to :post, index: true

      t.timestamps
    end
  end
end
