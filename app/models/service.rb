class Service < ApplicationRecord

  VALID_DATE_REGEX = /([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))/

  validates :nom, :uniqueness => true
  validates :nom, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 100 }
  
  validates_format_of :date_entree_vigueur, :with => VALID_DATE_REGEX, :on => :edit 
  validates_presence_of :nom, :description, :tarification_parent, :tarification_cisss

  acts_as_follower
  acts_as_followable

  audited only: [:futur_tarification_parent, :futur_tarification_cisss]

  #**************************
  # Search
  #**************************
  def self.search(search)
    where("nom LIKE ?", "%#{search}%")
    where("description LIKE ?", "%#{search}%")
  end 
end
