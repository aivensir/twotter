class Comment < ApplicationRecord
  belongs_to :posts, optional: true
end
