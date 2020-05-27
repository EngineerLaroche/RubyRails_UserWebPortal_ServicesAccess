#**************************************************************
# CONTROLEUR PAGES STATIQUES DU PORTAIL
#**************************************************************
class StaticPagesController < ApplicationController

  #**************************
  # Acceuil
  #**************************
  def home
  end

  #**************************
  # Aide
  #**************************
  def help
  end

  #**************************
  # A propos
  #**************************
  def about
  end

  #**************************
  # Nous joindre
  #**************************
  def contact
  end

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
end
