require 'rails_helper'

RSpec.describe User, type: :model do

  describe "#login_confirm" do

    it 'user is not exist' do
      expect(User.login_confirm("wrong@example.com", "wrong_password")).to eq ({ error: "邮箱或密码错误，请重试" })
    end

    it 'user is not activation' do
      user = create(:user, password: "correct_password", activation: false)
      expect(User.login_confirm(user.email, user.password)).to eq ({ error: "此邮箱还没有被激活，请激活后再尝试登录" })
    end

    it "password is not correct" do
      user = create(:user, password: "correct_password")
      expect(User.login_confirm(user.email, "wrong_password")).to eq ({ error: "邮箱或密码错误，请重试" })
    end

    it 'return trun' do
      user = create(:user, password: "correct_password")
      expect(User.login_confirm(user.email, user.password)).to eq ({ user_id: user.id })
    end

  end

end
