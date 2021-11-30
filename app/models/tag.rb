class Tag < ApplicationRecord
    validates :name, {presence: true}
    validates :name, {uniqueness: true}
    has_many :tag_words,dependent: :destroy
    has_many :words, through: :tag_words
    belongs_to :user
end
