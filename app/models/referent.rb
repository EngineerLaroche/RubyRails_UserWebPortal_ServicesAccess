class Referent < ApplicationRecord

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  RAPPORT_E_F_P = %w[N/A Email Fax Papier].freeze

  validates :pref_rapport_1, presence: true
  validates :pref_rapport_2, presence: true
  validates :pref_rapport_3, presence: true
  
  validates :email, :uniqueness => true
  validates :nom, presence: true, length: { maximum: 50 }
  validates :titre, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  
  validates_presence_of :nom, :prenom, :titre, :tel_bureau, :email

  acts_as_follower
  acts_as_followable

  #**************************
  # Recherche Referent
  #**************************
  def self.search(search)

      recherche = "%#{search}%"
      where("nom LIKE ? OR prenom LIKE ? OR titre LIKE ?
           OR tel_bureau LIKE ? OR organismes_id LIKE ?", 
            recherche, recherche, recherche,
            recherche, recherche)
  end


end
