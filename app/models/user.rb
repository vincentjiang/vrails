class User < ActiveRecord::Base
  rolify
  acts_as_authentic do |c|
    c.login_field = :email
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
    c.validates_format_of_email_field_options = {:with => Authlogic::Regex.email_nonascii}
    c.logged_in_timeout = 30.minutes # default is 10.minutes
  end

  has_many :posts

end
