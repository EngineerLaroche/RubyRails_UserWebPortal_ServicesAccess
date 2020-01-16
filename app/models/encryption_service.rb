#**************************************************************
# SERVICE ENCRYPTION
#**************************************************************
class EncryptionService < ApplicationRecord

	secret_key_base = ENV['DB_COL_ENCRYPTED_KEY']
  
  attr_encrypted :nom, :key=>secret_key_base
  attr_encrypted :description, :key=>secret_key_base
  attr_encrypted :tarification_parent, :key=>secret_key_base
  attr_encrypted :tarification_cisss, :key=>secret_key_base
end
