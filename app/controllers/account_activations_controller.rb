#**************************************************************
# CONTROLEUR ACTIVATION COMPTE
#**************************************************************
class AccountActivationsController < ApplicationController

  #**************************
  # Edit
  #**************************
  def edit

    # On identifie l'usager a partir d'un email
    user = User.find_by(email: params[:email])

    # Si le user n'es pas active et n'est pas authentifie
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user

      # Message qui confirme l'activation du compte usager
      flash[:success] = "Votre compte a été activé !"
      redirect_to root_path
    else

      # Message indique a l'usager que le lien d'activation est expire
      flash[:danger] = "Lien d'activation invalide."
      redirect_to root_url
    end
  end
end