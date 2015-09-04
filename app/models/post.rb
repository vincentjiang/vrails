class Post < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title

  validates :title, presence: true, uniqueness: true
  validates :content, presence: true

  belongs_to :user
  belongs_to :category

  scope :publish, -> { where(publish: true) }

  def increase_visite_times
    times = self.visite_times
    self.update(visite_times: times+1)
  end
end
