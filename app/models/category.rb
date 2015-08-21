class Category < ActiveRecord::Base
  resourcify

  validates :title, presence: true, uniqueness: true

  has_many :posts
end
