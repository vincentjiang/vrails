class Link < ActiveRecord::Base
  resourcify
  validates :title, :link, presence: true, uniqueness: true
end
