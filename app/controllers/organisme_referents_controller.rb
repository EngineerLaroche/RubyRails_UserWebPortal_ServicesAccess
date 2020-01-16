#**************************************************************
# CONTROLEUR ORGANISMES REFERENTS
#**************************************************************
require 'openssl'
class OrganismeReferentsController < ApplicationController

  #**************************
  # Liste Organisme Referent
  #**************************
  def index
    @organisme_referents = OrganismeReferent.where(activated: true).paginate(page: params[:page])

    # Si une recherche est lancée
    if params[:search]
      @organisme_referents = OrganismeReferent.search(params[:search]).order("created_at DESC")
    else
      @organisme_referents = OrganismeReferent.all.order('created_at DESC')
    end
  end

  #**************************
  # Afficher Information
  #**************************
  def show

    # Affiche l'Organisme Referent ainsi qu'une liste de referents et Organisme
    @organisme_referent = OrganismeReferent.find(params[:id])
    @referents = Referent.where(activated: true).paginate(page: params[:page])
    @organismes = Organisme.where(activated: true).paginate(page: params[:page])

    # Récupère le nombre d'objets associé à l'Organisme Referent
    qte_objets
  end

  #**************************
  # Quantité Objets
  #**************************
  def qte_objets

    # Affiche le nombre de Referent associé
    @vosreferents = @organisme_referent.follows_by_type('Referent').count
  end 

  #**************************
  # Nouvel Organisme Referent
  #**************************
  def new
    @organisme_referent = OrganismeReferent.new
  end

  #**************************
  # Creer Organisme Referent
  #**************************
  def create

    @organisme_referent = OrganismeReferent.new(organisme_referent_params)

    # Si on confirme la creation de l'organisme referent
    if @organisme_referent.save
      @organisme = Organisme.find_by(id: @organisme_referent.organismes_id)

      # Si l'ID entré n'est associé à aucuns ID Organisme
      if @organisme == nil && @organisme_referent.organismes_id != nil 
        flash[:danger] = "Il n'existe pas d'Organisme avec l'ID #{@organisme_referent.organismes_id}"
        render 'new' 
      else
        
        # Ajout de l'Organisme Referent a l'Organisme
        if @organisme_referent.organismes_id != nil
          @organisme.follow(@organisme_referent)
        end  

        flash[:success] = "Organisme Referent créé"
        redirect_to @organisme_referent
      end
    else
      render 'new'
    end
  end

  #*****************************
  # Modifier Organisme Referent
  #*****************************
  def edit
    @organisme_referent = OrganismeReferent.find(params[:id])
  end

  #*******************************
  # Mise a jour Organisme Referent
  #*******************************
  def update
    @organisme_referent = OrganismeReferent.find(params[:id])

    # Permet plus tard de verifier si un nouveau Organisme a été associé
    if @organisme_referent.organismes_id != nil
      @organisme_actuel = Organisme.find_by(id: @organisme_referent.organismes_id)
    end  
      
    if @organisme_referent.update_attributes(organisme_referent_params)
          @organisme = Organisme.find_by(id: @organisme_referent.organismes_id)

        # Si l'ID Organisme entré n'est associé a aucuns Organismes de la DB
        if @organisme == nil && @organisme_referent.organismes_id != nil
          flash[:danger] = "Il n'existe pas d'Organisme avec l'ID #{@organisme_referent.organismes_id}"
          redirect_to edit_organisme_referent_path 
        else 

          # Si un nouveau ID Organisme a été entré, on retire son ancienne association
          if @organisme_referent.organismes_id != nil
            if @organisme_actuel != @organisme && @organisme_actuel != nil
               @organisme_actuel.stop_following(@organisme_referent)
            end

            # On ajoute l'Organisme Referent a l'Organisme 
            @organisme.follow(@organisme_referent)

          # Si la case ID Organisme a été effacée et laissée vide, on retire l'association 
          elsif @organisme_referent.organismes_id == nil && @organisme != nil
            @organisme_actuel.stop_following(@organisme_referent)
          end

        flash[:success] = "Organisme referent mis à jour"
        redirect_to current_organisme_referent
      end
    else
      render 'edit'
    end
  end

  #*******************************
  # Supprimer Organisme Refrerent
  #*******************************
  def destroy

    # Supression de l'organisme referent
    OrganismeReferent.find(params[:id]).destroy
    flash[:success] = "Organisme referent supprimé"
    redirect_to organisme_referents_path
  end

  #***********************************
  # Page: Ajouter ou Retirer Referent
  #***********************************
  def ajouter_retirer_ref
    @organisme_referent = OrganismeReferent.find(params[:id])
    @referents = Referent.where(activated: true).paginate(page: params[:page])
  end  

  #**************************
  # Ajouter Referent
  #**************************
  def ajouter

    @organisme_referent = OrganismeReferent.find(params[:organisme_referent_id])

    # Si un ID Organisme a été entré, on créé uns association
    if @organisme_referent.organismes_id != nil 
      @organisme = Organisme.find_by(id: @organisme_referent.organismes_id)
      @organisme.follow(@organisme_referent)
    end

    # Association entre Referent et Organisme Referent
    @referent = Referent.find(params[:referent_id])
    @organisme_referent.follow(@referent)
    flash[:success] = "Vous avez ajouté #{@referent.nom} à l'organisme referent #{@organisme_referent.nom}"
    redirect_to ajouter_retirer_ref_organisme_referent_path(@organisme_referent)
  end

  #**************************
  # Retirer Referent
  #**************************
  def retirer

    @organisme_referent = OrganismeReferent.find(params[:organisme_referent_id])
    @referent = Referent.find(params[:referent_id])

    # Si un ID Organisme a été entré et qu'on est sur la page ajout/retirer de l'organisme Referent
    if @organisme_referent.organismes_id != nil && current_page?(ajouter_retirer_organisme_referent_path)
      @organisme = Organisme.find_by(id: @organisme_referent.organismes_id)
      @organisme.stop_following(@organisme_referent)
    else
      # Rupture de d'association avec le Referent
      @organisme_referent.stop_following(@referent)
    end
    flash[:success] = "Vous avez retiré #{@referent.nom} de l'organisme referent #{@organisme_referent.nom}"
    redirect_to ajouter_retirer_ref_organisme_referent_path(@organisme_referent)
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

  #*******************************
  # Parametre Organisme Referent
  #*******************************
  def organisme_referent_params
    params.require(:organisme_referent).permit(:nom, :tel, :fax, :email, :website, :no_civique, :rue, :ville, :province, :code_postal, :est_actif, :organismes_id)
  end
end