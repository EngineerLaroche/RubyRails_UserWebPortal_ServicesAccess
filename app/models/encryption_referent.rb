#**************************************************************
# REFERENT ENCRYPTION
#**************************************************************
class EncryptionReferent < ApplicationRecord

secret_key_base = ENV['DB_COL_ENCRYPTED_KEY']
  
  attr_encrypted :nom, :key=>secret_key_base
  attr_encrypted :prenom, :key=>secret_key_base
  attr_encrypted :titre, :key=>secret_key_base
  attr_encrypted :email, :key=>secret_key_base
  attr_encrypted :tel_bureau, :key=>secret_key_base
  attr_encrypted :tel_cell, :key=>secret_key_base
  attr_encrypted :fax, :key=>secret_key_base
end
