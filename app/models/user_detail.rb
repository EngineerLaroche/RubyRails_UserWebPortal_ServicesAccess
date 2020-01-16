#**************************************************************
# USER ENCRYPTION
#**************************************************************
class UserDetail < ApplicationRecord

  secret_key_base = ENV['DB_COL_ENCRYPTED_KEY']
  attr_encrypted :email, :key=>secret_key_base
  attr_encrypted :password_digest, :key=>secret_key_base
end
