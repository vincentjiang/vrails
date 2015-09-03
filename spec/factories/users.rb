FactoryGirl.define do
  factory :user do
    email "username@example.com"
    username "UserName"
    admin true
    last_login_time ""
    avatar "MyString"
    activation true
  end

end
