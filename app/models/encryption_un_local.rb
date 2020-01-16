#**************************************************************
# LOCAL ENCRYPTION
#**************************************************************
class EncryptionUnLocal < ApplicationRecord

	secret_key_base = ENV['DB_COL_ENCRYPTED_KEY']
  
  attr_encrypted :nom, :key=>secret_key_base
  attr_encrypted :qte_places, :key=>secret_key_base

end
