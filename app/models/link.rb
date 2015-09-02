class Link < ActiveRecord::Base
  validates :title, :link, presence: true, uniqueness: true
end
