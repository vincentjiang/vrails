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

  def self.login_confirm(email, password)
    user = User.find_by(email: email)
    result = if user
               if !user.activation?
                 { error: "此邮箱还没有被激活，请激活后再尝试登录" }
               elsif !user.authenticate(password)
                 { error: "邮箱或密码错误，请重试" }
               else
                 user.update_last_login_time
                 { user_id: user.id }
               end
             else
               { error: "邮箱或密码错误，请重试" }
             end
  end

end
