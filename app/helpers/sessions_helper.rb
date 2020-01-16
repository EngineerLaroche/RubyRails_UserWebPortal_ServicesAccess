#**************************************************************
# SUPPORT SESSION
#**************************************************************
module SessionsHelper

  #**************************
  # Connexion d'un user
  #**************************
  def log_in(user)
    session[:user_id] = user.id
  end

  #***********************************
  # Maintient session
  #***********************************
  def remember(user)
    user.remember

    # Garde la session en memoire
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  #***********************************
  # Retourne vrai si user actuel
  #***********************************
  def current_user?(user)
    user == current_user
  end

  #***********************************
  # User actuel
  #***********************************
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)

    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)

      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user

        # Retourne le user associé au Token
        @current_user = user
      end
    end
  end

  #***********************************
  # User connecté
  #***********************************
  def logged_in?

    # Retourne vrai si user connecté
    !current_user.nil?
  end

  #**************************************
  # Oublier User
  #**************************************
  def forget(user)
    user.forget

    # Ne garde plus la session en memoire
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  #***********************************
  # Deconnexion User
  #***********************************
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  #***********************************
  # Redirige pages
  #***********************************
  def redirect_back_or(default)

    # Retour avant ou arriere de la page
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  #***********************************
  # Sauvegarde pages
  #***********************************
  def store_location

    # Garde en memoire les URL pour y re-acceder
    session[:forwarding_url] = request.original_url if request.get?
  end

  #***********************************
  # Retourne vrai si Organisme actuel
  #***********************************
  def current_organisme?(organisme)
    organisme == current_organisme
  end

  #***********************************
  # Organisme actuel
  #***********************************
  def current_organisme

    # Capture l'ID de la page actuel de l'Organisme
    if (organisme_id = params[:id])

      # Retourne l'Organisme actuel
      @current_organisme ||= Organisme.find_by(id: organisme_id)
    end
  end

  #*******************************************
  # Retourne vrai si Organisme Referent actuel
  #*******************************************
  def current_organisme_referent?(organisme_referent)
    organisme_referent == current_organisme_referent
  end

  #***********************************
  # Organisme Referent actuel
  #***********************************
  def current_organisme_referent

    # Capture l'ID de la page actuel de l'Organisme Referent
    if (organisme_referent_id = params[:id])

      # Retourne l'Organisme actuel
      @current_organisme_referent ||= OrganismeReferent.find_by(id: organisme_referent_id)
    end
  end

  #***********************************
  # Retourne vrai si Referent actuel
  #***********************************
  def current_referent?(referent)
    referent == current_referent
  end

  #***********************************
  # Referent actuel
  #***********************************
  def current_referent

    # Capture l'ID de la page actuel du Referent
    if (referent_id = params[:id])

      # Retourne l'Organisme actuel
      @current_referent ||= Referent.find_by(id: referent_id)
    end
  end

  #***********************************
  # Retourne vrai si Local actuel
  #***********************************
  def current_un_local?(un_local)
    un_local == current_un_local
  end

  #***********************************
  # Local actuel
  #***********************************
  def current_un_local

    # Capture l'ID de la page actuel du Local
    if (un_local_id = params[:id])

      # Retourne le Local actuel
      @current_un_local ||= UnLocal.find_by(id: un_local_id)
    end
  end

  #********************************************
  # Retourne vrai si Point de Service actuel
  #********************************************
  def current_point_of_service?(point_of_service)
    point_of_service == current_point_of_service
  end

  #***********************************
  # Point de Service actuel
  #***********************************
  def current_point_of_service

    # Capture l'ID de la page actuel du Point de service
    if (point_of_service_id = params[:id])

      # Retourne le point de service actuel
      @current_point_of_service ||= PointOfService.find_by(id: point_of_service_id)
    end
  end

  #********************************************
  # Retourne vrai si Service actuel
  #********************************************
  def current_service?(service)
    service == current_service
  end

  #***********************************
  # Service actuel
  #***********************************
  def current_service

    # Capture l'ID de la page actuel du service
    if (service_id = params[:id])

      # Retourne le service actuel
      @current_service ||= Service.find_by(id: service_id)
    end
  end
end