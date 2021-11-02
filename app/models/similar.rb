class Similar < ApplicationRecord
    validates :name, {presence: true}
    belongs_to :word
end
