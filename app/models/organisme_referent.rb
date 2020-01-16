class OrganismeReferent < ApplicationRecord

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  PROVINCES = %w[Quebec Ontario Colombie-Britanique Alberta Nouvelle-Ecosse Manitoba Saskatchewan Nouveau-Brunswick Terre-Neuve ].freeze

  validates :nom, :uniqueness => true
  validates :nom, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates_presence_of :nom, :tel, :no_civique, :rue, :ville, :province, :code_postal

  before_save   :downcase_email

  acts_as_followable
  acts_as_follower

  #**************************
  # Search
  #**************************
  def self.search(search)
    where("nom LIKE ?", "%#{search}%")
    where("email LIKE ?", "%#{search}%")
  end

  private

  #***********************************
  # Lettre minuscule email
  #***********************************
  def downcase_email
    self.email = email.downcase
  end
end
