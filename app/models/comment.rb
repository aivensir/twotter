class Comment < ApplicationRecord
  belongs_to :posts, optional: true
  belongs_to :users, optional: true
end
