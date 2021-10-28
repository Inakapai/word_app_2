class TagWord < ApplicationRecord
  belongs_to :tag
  belongs_to :word
end
