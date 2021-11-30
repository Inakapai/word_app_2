class User < ApplicationRecord
    validates :name, presence: true
    validates :email, {presence: true, uniqueness: true}
    has_many :tags #wordbookとかもアソシエーション追加した方が良さそう
    has_secure_password 
end
