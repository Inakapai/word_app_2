class Word < ApplicationRecord
    validates :name, :meaning, {presence: true}
    validates :name, {uniqueness: true}
    has_many :similars,dependent: :destroy
    has_many :tag_words,dependent: :destroy
    has_many :tags, through: :tag_words
    accepts_nested_attributes_for :similars, allow_destroy: true
    #accepts_nested_attributes_for :tag_words, allow_destroy: true

    class << self
        def word_size_valid?
            self.count > self.minimum_size
        end

        def minimum_size
            9
        end
    end
end
