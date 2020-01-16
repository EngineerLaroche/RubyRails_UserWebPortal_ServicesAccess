#**************************************************************
# USER
#**************************************************************
class User < ApplicationRecord

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save   :downcase_email
  before_create :create_activation_digest

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :role, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  has_secure_password

  ROLES = %w[intervenant adjcoordonateur coordonateur directeur].freeze
  ROLES2 = %w[intervenant adjcoordonateur coordonateur].freeze


  #***********************************
  # Digest user
  #***********************************
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

    # Retourne le hash Digest du string reçu
    BCrypt::Password.create(string, cost: cost)
  end

  #***********************************
  # Quantite LogIn
  #***********************************
  def count_login
    increment :sign_in_count
  end

  #**************************
  # Search
  #**************************
  def self.search(search)
    where("role LIKE ?", "%#{search}%")
    where("name LIKE ?", "%#{search}%")
  end

  #***********************************
  # Token
  #***********************************
  def self.new_token

    # Retourne un Token generé au hasard
    SecureRandom.urlsafe_base64
  end

  #***********************************
  # Base de donne User
  #***********************************
  def remember
    self.remember_token = User.new_token

    # Pour supporter le maintient d'une session ouverte
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #***********************************
  # Authentifié
  #***********************************
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    # Retourne vrai si le Token correspond au Digest
    BCrypt::Password.new(digest).is_password?(token)
  end

  #***********************************
  # Oublier
  #***********************************
  def forget

    # Ne garde plus en memoire un user sur sa session sur un poste
    update_attribute(:remember_digest, nil)
  end

  #***********************************
  # Activation compte
  #***********************************
  def activate
    update_attribute(:activated, true)

    # Systeme confirme l'activation du nouveau compte
    update_attribute(:activated_at, Time.zone.now)
  end

  #***********************************
  # Email activation
  #***********************************
  def send_activation_email

    # Systeme envoi un email d'activation apres la creation d'un nouveau compte
    UserMailer.account_activation(self).deliver_now
  end

  #***********************************
  # Attribut Mot de Passe
  #***********************************
  def create_reset_digest
    self.reset_token = User.new_token

    # Associe l'attribut reset au changement du mot de passe
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end
  #***********************************
  # Email reset mot de passe
  #***********************************
  def send_password_reset_email

    # Systeme envoi un email au user pour reinitialiser son mot de passe
    UserMailer.password_reset(self).deliver_now
  end

  #***********************************
  # Email reset mot de passe expiré
  #***********************************
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

    #***********************************
    # Lettre minuscule email
    #***********************************
    def downcase_email
      self.email = email.downcase
    end

    #*************************************
    # Creation et assignation Token actif
    #*************************************
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end

