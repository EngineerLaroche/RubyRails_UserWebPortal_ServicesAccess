#**************************************************************
# CONTROLEUR APPLICATION
#**************************************************************
class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  include SessionsHelper

  private

    #*************************
    # Confirme user connecte
    #*************************
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Veuillez vous connecter."
        redirect_to login_url
      end
    end
end