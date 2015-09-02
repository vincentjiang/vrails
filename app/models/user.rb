class User < ActiveRecord::Base
  has_secure_password

  has_many :posts

  validates :username, length: { minimum: 5, maximum: 20 }, uniqueness: true
  validates :email, format: { with: /\A[a-zA-Z0-9\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z]+\z/ }, uniqueness: true
  validates :password, length: { minimum: 6 }, confirmation: true, if: :need_validate_password?

  def update_last_login_time
    self.update(last_login_time: DateTime.now)
  end

  def need_validate_password?
    new_record? || password.present?
  end

  def can_manage?(post)
    self.id == post.user_id
  end
end
