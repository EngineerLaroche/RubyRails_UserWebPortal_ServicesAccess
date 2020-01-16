#**************************************************************
# CONTROLEUR DE REINITIALISATION DE MOT DE PASSE
#**************************************************************
class PasswordResetsController < ApplicationController

  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  #**************************
  # New
  #**************************
  def new
  end

  #**************************
  # Demande Reset Password
  #**************************
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)

    # Si la base de donne reconnait le user 
    if @user

      #Processus de renitialisation de mot de passe par email
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email envoyé avec les instruction de réinitialisation de votre mot de passe."
      redirect_to root_url
    
    else
      flash.now[:danger] = "Email inconnu."
      render 'new'
    end
  end

  #**************************
  # Edit
  #**************************
  def edit
  end

  #**************************
  # Mise a Jour Password
  #**************************
  def update

    # Si une case est vide, on insiste pour qu'elle contienne de l'information
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Votre mot de passe a été réinitialisé !"
      redirect_to root_path
    
    else
      render 'edit'
    end
  end

  private

    #**************************
    # Parametres user
    #**************************
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    #**************************
    # Obtenir user
    #**************************
    def get_user
      @user = User.find_by(email: params[:email])
    end

    #**************************
    # Confirme validite user
    #**************************
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    #**************************
    # Verif. Expiration Token
    #**************************
    def check_expiration

      # Si le user depasse le delais de renitialisation par email
      if @user.password_reset_expired?
        flash[:danger] = "La rénitialisation du mot de passe est expiré."
        redirect_to new_password_reset_url
      end
    end
end