#**************************************************************
# CONTROLEUR POINT DE SERVICES
#**************************************************************
require 'openssl'
class PointOfServicesController < ApplicationController

  #**************************
  # Liste Point de Service
  #**************************
  def index
    @point_of_services = PointOfService.where(activated: true).paginate(page: params[:page])

    # Si une recherche est lancée
    if params[:search]
      @point_of_services = PointOfService.search(params[:search]).order("created_at DESC")
    else
      @point_of_services = PointOfService.all.order('created_at DESC')
    end
  end

  #******************************
  # Affiche info Point de Service
  #******************************
  def show
    @point_of_service = PointOfService.find(params[:id])

    # Permet d'afficher la liste des locaux sur la page qui affiche l'information Organisme
    @un_locals = UnLocal.where(activated: true).paginate(page: params[:page])
    @organismes = Organisme.where(activated: true).paginate(page: params[:page])

    # Permet de recuperer le nombre d'objets que le Point de Service possede
    qte_objets
  end

  #**************************
  # Quantité Objets
  #**************************
  def qte_objets

    # Permet d'afficher le nombre de locaux que possede le Point de Service
    @voslocaux = @point_of_service.follows_by_type('UnLocal').count 
  end 

  #**************************
  # Nouveau Point de Service
  #**************************
  def new
    @point_of_service = PointOfService.new
  end

  #**************************
  # Creer Point de Service
  #**************************
  def create
    @point_of_service = PointOfService.new(point_of_service_params)

    # Si l'utilisateur confirme la creation d'un organisme
    if @point_of_service.save
      @organisme = Organisme.find_by(id: @point_of_service.organismes_id)

      # Si l'ID entré n'es associé à aucun Organisme
      if @organisme == nil && @point_of_service.organismes_id != nil
        flash[:danger] = "Il n'existe pas d'Organisme avec l'ID #{@point_of_service.organismes_id}"
        render 'new'
      else
        
        # Si un ID Organisme a été entré
        if @point_of_service.organismes_id != nil
          @organisme.follow(@point_of_service)
        end  

        flash[:success] = "Point de service créé"
        redirect_to @point_of_service
      end  
    else
      render 'new'
    end
  end

  #**************************
  # Modifier Point de Service
  #**************************
  def edit
    @point_of_service = PointOfService.find(params[:id])
  end

  #*****************************
  # Mise a jour Point de Service
  #*****************************
  def update
    @point_of_service = PointOfService.find(params[:id])

     # Si le point de service est deja associé à un Organisme 
    if @point_of_service.organismes_id != nil
      @organisme_actuel = Organisme.find_by(id: @point_of_service.organismes_id)
    end 

    # Si on procede a la mise a jour du point de service
    if @point_of_service.update_attributes(point_of_service_params)
        @organisme = Organisme.find_by(id: @point_of_service.organismes_id)

        # Si l'ID n'est associé avec aucuns Organismes de la DB
        if @organisme == nil && @point_of_service.organismes_id != nil
          flash[:danger] = "Il n'existe pas d'Organisme avec l'ID #{@point_of_service.organismes_id}"
          redirect_to edit_point_of_service_path  
        else 

          # Si l'ID Organisme a été changé pour être associé à un autre Organisme
          if @point_of_service.organismes_id != nil 
            if @organisme_actuel != @organisme && @organisme_actuel != nil
               @organisme_actuel.stop_following(@point_of_service)
            end

          # On ajoute le Point de Service a l'Organisme 
          @organisme.follow(@point_of_service)

          # Si la case ID Organisme a été effacée et laissée vide, on retire le Point de Service de l'Organisme 
          elsif @point_of_service.organismes_id == nil && @organisme_actuel != nil
            @organisme_actuel.stop_following(@point_of_service)
          end

          flash[:success] = "Point de service mis à jour"
          redirect_to current_point_of_service
        end  
    else
      render 'edit'
    end
  end

  #****************************
  # Supprimer Point de Service
  #****************************
  def destroy

    # Supression de l'organisme
    point_of_service.find(params[:id]).destroy
    flash[:success] = "Point de service supprimé"

    # Retourne sur la liste des points de services
    redirect_to point_of_services_path
  end

  #*****************************************
  # Page: Ajouter ou Retirer Local
  #*****************************************
  def ajouter_retirer_local
    @point_of_service = PointOfService.find(params[:id])
    @un_locals = UnLocal.where(activated: true).paginate(page: params[:page])
  end

  #****************************
  # Ajouter Local
  #****************************
  def ajouter

    @point_of_service = PointOfService.find(params[:point_of_service_id]) 
    @un_local = UnLocal.find(params[:un_local_id])

    # Si on souhaite ajouter un local et qu'il est deja avec un autre Point de service.
    if @un_local.point_of_services_id != nil

        # On retire le local actuel pour permettre un nouvel ajout a un autre point de service
        @point_of_service = PointOfService.find_by(id: @un_local.point_of_services_id)
        @point_of_service.stop_following(@un_local)
    end  

      # On associe le local avec le point de service et on met a jour
      @point_of_service = PointOfService.find(params[:point_of_service_id]) 
      @point_of_service.follow(@un_local)
      @un_local.update_column(:point_of_services_id, current_point_of_service.id)


    flash[:success] = "Vous avez ajouté le local #{@un_local.nom} au point de service #{@point_of_service.nom}"
    redirect_to ajouter_retirer_local_point_of_service_path(@point_of_service)
  end

  #****************************
  # Retirer Local
  #****************************
  def retirer

    @point_of_service = PointOfService.find(params[:point_of_service_id]) 
    @un_local = UnLocal.find(params[:un_local_id])

    # Le point de service retire un local et on met a jour l'ID
    @point_of_service.stop_following(@un_local)
    @un_local.update_column(:point_of_services_id, nil)

    flash[:warning] = "Vous avez retiré le local #{@un_local.nom} du point de service #{@point_of_service.nom}"
    redirect_to ajouter_retirer_local_point_of_service_path(@point_of_service)
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

  #*****************************
  # Parametre Point de Service
  #*****************************

  def point_of_service_params
    params.require(:point_of_service).permit(:nom, :email, :tel, :fax, :no_civique,:rue,:ville,:province,:code_postal, :organismes_id)
  end
end
