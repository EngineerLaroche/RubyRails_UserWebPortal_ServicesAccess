#**************************************************************
# POINT DE SERVICE ENCRYPTION
#**************************************************************
class EncryptionPointOfService < ApplicationRecord

secret_key_base = ENV['DB_COL_ENCRYPTED_KEY']
	
	attr_encrypted :nom, :key=>secret_key_base
  attr_encrypted :email, :key=>secret_key_base
  attr_encrypted :tel, :key=>secret_key_base
  attr_encrypted :fax, :key=>secret_key_base
  attr_encrypted :no_civique, :key=>secret_key_base
  attr_encrypted :rue, :key=>secret_key_base
  attr_encrypted :ville, :key=>secret_key_base
  attr_encrypted :province, :key=>secret_key_base
  attr_encrypted :code_postal, :key=>secret_key_base
end
