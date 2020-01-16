#**************************************************************
# CONTROLEUR USER
#**************************************************************
require 'openssl'
class UsersController < ApplicationController

  before_action :logged_in_user,        only: [:index, :edit, :update, :destroy]
  before_action :correct_user,          only: [:edit, :update]
  before_action :supression_user,       only: :destroy

  #**************************
  # Index
  #**************************
  def index
    @users = User.where(activated: true).paginate(page: params[:page])

    # Si la recherche est lancée
    if params[:search]
      @users = User.search(params[:search]).order("created_at DESC")
    else
      @users = User.all.order('created_at DESC')
    end
  end

  #**************************
  # Show
  #**************************
  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end

  #**************************
  # New
  #**************************
  def new
    @user = User.new
  end

  #**************************
  # Create
  #**************************
  def create
    @user = User.new(user_params)

    # Si l'utilisateur confirme la creation du compte
    if @user.save

      # Le systeme envoi un email a l'utilisateur pour activer son compte
      @user.send_activation_email
      flash[:info] = "Le nouvel usager doit consulter ses emails pour activer son compte."
      redirect_to root_url
    else
      render 'new'
    end
  end

  #**************************
  # Edit
  #**************************
  def edit
    @user = User.find(params[:id])
  end

  #**************************
  # Update
  #**************************
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Compte mis à jour"
      redirect_to root_url
    else
      render 'edit'
    end
  end

  #**************************
  # Destroy
  #**************************
  def destroy

    # Supression d'un usager du systeme 
    User.find(params[:id]).destroy
    flash[:success] = "Usager supprimé"
    redirect_to users_url
  end

  #**************************
  # Encrypter
  #**************************
    def encrypt(key)
      cipher = OpenSSL::Cipher::Cipher.new('DES-EDE3-CBC').encrypt
      cipher.key = Digest::SHA1.hexdigest key
      s = cipher.update(self) + cipher.final

      s.unpack('H*')[0].upcase
    end
  
  #**************************
  # Decrypter
  #**************************
    def decrypt(key)
      cipher = OpenSSL::Cipher::Cipher.new('DES-EDE3-CBC').decrypt
      cipher.key = Digest::SHA1.hexdigest key
      s = [self].pack("H*").unpack("C*").pack("c*")

      cipher.update(s) + cipher.final
    end

  private

    #**************************
    # Parametre User
    #**************************
    def user_params
      params.require(:user).permit(:role, :name, :email, :password, :password_confirmation, :supression)
    end

    #**************************
    # Confirme etre un User
    #**************************
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    #**********************************
    # Permet aux users la supression.
    # Le type de role donne acces 
    # a l'option supprimer.
    #**********************************
    def supression_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user.supression?
    end
end