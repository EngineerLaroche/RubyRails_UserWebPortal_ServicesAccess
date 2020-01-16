#**************************************************************
# CONTROLEUR ORGANISMES REFERENTS
#**************************************************************
require 'openssl'
class ReferentsController < ApplicationController

  #**************************
  # Liste Referent
  #**************************
  def index
    @referents = Referent.where(activated: true).paginate(page: params[:page])

    # Si une recherche est lancée
    if params[:search]
        @referents = Referent.search(params[:search]).order("created_at DESC")
    else
      @referents = Referent.all.order('created_at DESC')
    end
  end

  #**************************
  # Afficher info Referent
  #**************************
  def show
    @referent = Referent.find(params[:id])

    # Permet d'afficher l'information complet d'un Organisme associé au Referent
    @organismes = Organisme.where(activated: true).paginate(page: params[:page])

  end

  #**************************
  # Nouveau Referent
  #**************************
  def new
    @referent = Referent.new
  end

  #**************************
  # Creer Referent
  #**************************
  def create
    @referent = Referent.new(referent_params)

    # Si l'utilisateur confirme la creation d'un referent
    if @referent.save

      flash[:success] = "Referent créé"
      redirect_to @referent
    else
      render 'new'
    end
  end

  #**************************
  # Modifier Referent
  #**************************
  def edit
    @referent = Referent.find(params[:id])
  end

  #**************************
  # Mise a jour Referent
  #**************************
  def update
    @referent = Referent.find(params[:id])
    if @referent.update_attributes(referent_params)
      flash[:success] = "Referent mis à jour"
      redirect_to current_referent
    else
      render 'edit'
    end
  end

  #**************************
  # Supprimer Referent
  #**************************
  def destroy

    # Supression du referent
    Referent.find(params[:id]).destroy
    flash[:success] = "Referent supprimé"
    redirect_to referents_path
  end

  #**************************
  # Ajouter (Usage futur)
  #**************************
  def ajouter
  end

  #**************************
  # Retirer (Usage futur)
  #**************************
  def retirer
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
  # Parametre Referent
  #**************************
  def referent_params
    params.require(:referent).permit(:nom, :prenom, :titre, :tel_bureau, :tel_cell, :fax, :email,:organismes_id, :pref_rapport_1, :pref_rapport_2, :pref_rapport_3)
  end
end
