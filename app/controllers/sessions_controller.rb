#**************************************************************
# CONTROLEUR DE SESSION
#**************************************************************
class SessionsController < ApplicationController

@@counter = 0

  #**************************
  # New
  #**************************
  def new
  end

  #**************************
  # Create
  #**************************
  def create
    user = User.find_by(email: params[:session][:email].downcase)

    # Si la base de donne reconnait le user
    if user && user.authenticate(params[:session][:password])

      # Si le compte du user est deja activé
      if user.activated?

        # Compte le nombre de fois que le user s'est connecté
        user.count_login

        # Procede a la connexion au compte de l'usager
        log_in user

        # Garde en memoire le email du user pour un acces rapide
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        #redirect_back_or user
        redirect_to root_path
      else

        # Si le nouveau compte n'est pas activé, on affiche un message
        message  = "Votre compte n'a pas encore été activé. "
        message += "Veuillez consulter vos emails pour retrouver le lien d'activation."
        flash[:warning] = message
        redirect_to root_url
      end
    else

      loop do

        # On incremente lorsqu'un fail login (mauvais mot de passe)
        @@counter += 1

        if @@counter < 3
          if user	
            if @@counter == 2

              flash.now[:danger] = "Vous n'avez pas entré le bon mot de passe ! Il vous reste une dernière tentative de connexion !"
              render 'new'
              break
            else
        	   flash.now[:danger] = "Vous n'avez pas entré le bon mot de passe !" 
             render 'new'
             break
           end
          else
             flash.now[:danger] = "Le email entré n'a pas été trouvé dans la base de donnée !"
             render 'new'
             break
          end
        end

        if @@counter == 3

     		   #Processus de renitialisation de mot de passe par email
      		user.create_reset_digest
      		user.send_password_reset_email	
      		
          redirect_to root_url
          flash[:info] = "Email envoyé avec les instruction de réinitialisation de votre mot de passe."

          @@counter = 0
          break
        end
      end
    end
  end                       

  #**************************
  # Destroy
  #**************************
  def destroy

    # La deconnexion est autorisé seulement si le user est deja connecté
    log_out if logged_in?
    redirect_to root_url
  end
end                                       