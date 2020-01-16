#**************************************************************
# CONTROLEUR ORGANISMES
#**************************************************************
require 'openssl'
class OrganismesController < ApplicationController

  #**************************
  # Liste Organisme
  #**************************
  def index
    @organismes = Organisme.where(activated: true).paginate(page: params[:page])

    # Si une recherche est lancée
    if params[:search]
      @organismes = Organisme.search(params[:search]).order("created_at DESC")
    else
      @organismes = Organisme.all.order('created_at DESC')
    end
  end

  #**************************
  # Affiche Information
  #**************************
  def show
    @organisme = Organisme.find(params[:id])

    # Affiche une liste des Referents, Points de Services et Organismes Referents 
    @referents = Referent.where(activated: true).paginate(page: params[:page])
    @point_of_services = PointOfService.where(activated: true).paginate(page: params[:page])
    @organisme_referents = OrganismeReferent.where(activated: true).paginate(page: params[:page])

    # Recupere le nombre d'objets par categorie que l'Organisme possede
    qte_objets
    
  end

  #**************************
  # Quantité Objets
  #**************************
  def qte_objets

    # Affiche les Referents, Points de Services et Organisme Referents que possede l'organisme
    @vosreferents = @organisme.follows_by_type('Referent').count
    @vospointservices = @organisme.follows_by_type('PointOfService').count
    @vosorganismereferents = @organisme.follows_by_type('OrganismeReferent').count
  end 

  #**************************
  # Nouvel Organisme
  #**************************
  def new
    @organisme = Organisme.new
  end

  #**************************
  # Creer Organisme
  #**************************
  def create
    @organisme = Organisme.new(organisme_params)

    # Confirme la creation d'un organisme
    if @organisme.save
      flash[:success] = "Organisme créé"
      redirect_to @organisme
    else
      render 'new'
    end
  end

  #**************************
  # Modifier Organisme
  #**************************
  def edit
    @organisme = Organisme.find(params[:id])
  end

  #**************************
  # Mise a jour Organisme
  #**************************
  def update
    @organisme = Organisme.find(params[:id])

    # Met a jour l'information
    if @organisme.update_attributes(organisme_params)
      flash[:success] = "Organisme mis à jour"
      redirect_to current_organisme
    else
      render 'edit'
    end
  end

  #**************************
  # Supprimer Organisme
  #**************************
  def destroy

    # Supression de l'organisme
    Organisme.find(params[:id]).destroy
    flash[:success] = "Organisme supprimé"

    # Redirige vers la liste des Organismes
    redirect_to organismes_path
  end

  #********************************************
  # Page: Ajouter ou Retirer Organisme Referent
  #********************************************
  def ajouter_retirer_org_ref
    @organisme = Organisme.find(params[:id])
    @organisme_referents = OrganismeReferent.where(activated: true).paginate(page: params[:page])
  end

  #*****************************************
  # Page: Ajouter ou Retirer Referent
  #*****************************************
  def ajouter_retirer_ref
    @organisme = Organisme.find(params[:id])
    @referents = Referent.where(activated: true).paginate(page: params[:page])
  end

  #********************************************
  # Page: Ajouter ou Retirer Point de Service
  #********************************************
  def ajouter_retirer_point_service
    @organisme = Organisme.find(params[:id])
    @point_of_services = PointOfService.where(activated: true).paginate(page: params[:page])
  end   


  #****************************************************************************************
  #                               Ajouter Objets
  #****************************************************************************************     

  #*********************************
  # Ajouter un Objet a l'Organisme
  #*********************************
  def ajouter

    @organisme = Organisme.find(params[:organisme_id]) 

    # Pour l'ajout d'un Organisme Referent a l'Organisme
    if params[:organisme_referent_id]
      ajouter_organisme_referent
    
    # Pour l'ajout d'un Referent a l'Organisme
    elsif params[:referent_id]
      ajouter_referent

    # Pour l'ajout d'un Point de Service a l'Organisme  
    elsif params[:point_of_service_id]
       ajouter_point_service
    end   
  end

  #*********************************
  # Ajout d'un Organisme Referent
  #*********************************
  def ajouter_organisme_referent

    # Recupere l'Organisme Referent' et l'ajoute a Organisme
    @organisme_referent = OrganismeReferent.find(params[:organisme_referent_id])
    processus_ajouter(@organisme_referent)
      
    flash[:success] = "Vous avez ajouté l'organisme referent #{@organisme_referent.nom} à l'organisme #{@organisme.nom}"
    redirect_to ajouter_retirer_org_ref_organisme_path(@organisme)
  end  

  #*********************************
  # Ajout d'un Referent
  #*********************************
  def ajouter_referent

    # On associe le Referent avec l'Organisme
    @organisme = Organisme.find(params[:organisme_id]) 
    @referent = Referent.find(params[:referent_id])
    @organisme.follow(@referent)

    flash[:success] = "Vous avez ajouté le referent #{@referent.prenom} à l'organisme #{@organisme.nom}"
    redirect_to ajouter_retirer_ref_organisme_path(@organisme) 
  end 

  #*********************************
  # Ajout d'un Point de Service
  #*********************************
  def ajouter_point_service

    # Recupere le Point de Service et l'ajoute a Organisme
    @point_of_service = PointOfService.find(params[:point_of_service_id])
    processus_ajouter(@point_of_service)

    flash[:success] = "Vous avez ajouté le point de service #{@point_of_service.nom} à l'organisme #{@organisme.nom}"
    redirect_to ajouter_retirer_point_service_organisme_path(@organisme) 
  end  

  #*********************************
  # Processus d'Ajout Universel
  #*********************************
  def processus_ajouter(objet)

      # Si on souhaite ajouter l'objet et qu'il est deja avec un autre Organisme.
      if objet.organismes_id != nil

        # Recupere l'ID Organisme et retire l'objet actuel 
        @un_organisme = Organisme.find_by(id: objet.organismes_id)
        @un_organisme.stop_following(objet)
      end  

      # Ajoute l'objet a l'Organisme et met a jour son organismes_id
      @organisme = Organisme.find(params[:organisme_id]) 
      @organisme.follow(objet)
      objet.update_column(:organismes_id, current_organisme.id)
  end   


  #****************************************************************************************
  #                               Retirer Objets
  #****************************************************************************************

  #*********************************
  # Retirer un Objet a l'Organisme
  #*********************************
  def retirer

    # Pour retirer un Organisme Referent a l'Organisme
    if params[:organisme_referent_id]
      retirer_organisme_referent
    
    # Pour retirer un Referent a l'Organisme
    elsif params[:referent_id]
      retirer_referent

    # Pour retirer un Point de Service a l'Organisme  
    elsif params[:point_of_service_id]
      retirer_point_service    
    end   
  end

  #*********************************
  # Retirer un Organisme Referent
  #*********************************
  def retirer_organisme_referent

    # Recupere l'Organisme Referent et le retire de l'Organisme
    @organisme_referent = OrganismeReferent.find(params[:organisme_referent_id]) 
    processus_retirer(@organisme_referent)
      
    flash[:warning] = "Vous avez retiré l'organisme referent #{@organisme_referent.nom} de l'organisme #{@organisme.nom}"
    redirect_to ajouter_retirer_org_ref_organisme_path(@organisme)
  end

  #*********************************
  # Retirer un Referent
  #*********************************
  def retirer_referent

    # Recupere le Referent et le retire de l'Organisme
    @referent = Referent.find(params[:referent_id])
    processus_retirer(@referent)

    flash[:warning] = "Vous avez retiré le referent #{@referent.prenom} de l'organisme #{@organisme.nom}"
    redirect_to ajouter_retirer_ref_organisme_path(@organisme) 
  end
  
  #*********************************
  # Retirer un Point de Service
  #*********************************
  def retirer_point_service

    # Recupere le Point de Service et le retire de l'Organisme
    @point_of_service = PointOfService.find(params[:point_of_service_id])
    processus_retirer(@point_of_service)

    flash[:warning] = "Vous avez retiré le point de service #{@point_of_service.nom} de l'organisme #{@organisme.nom}"
    redirect_to ajouter_retirer_point_service_organisme_path(@organisme)
  end  

  #*********************************
  # Processus Retirer Universel
  #*********************************
  def processus_retirer(objet)

    # On defait l'association entre l'objet et l'Organisme et met a jour son organismes_id
    @organisme = Organisme.find(params[:organisme_id])
    @organisme.stop_following(objet)
    objet.update_column(:organismes_id, nil)
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
  # Parametre Organisme
  #**************************
  def organisme_params
    params.require(:organisme).permit(:nom, :email, :tel, :fax, :no_civique, :rue, :ville, :province, :code_postal)
  end
end