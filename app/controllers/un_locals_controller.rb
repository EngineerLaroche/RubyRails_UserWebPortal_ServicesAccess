#**************************************************************
# CONTROLEUR LOCALS
#**************************************************************
require 'openssl'
class UnLocalsController < ApplicationController

  	#**************************
    # Index
    #**************************
    def index
      @un_locals = UnLocal.where(activated: true).paginate(page: params[:page])

      # Si la recherche est lancée
      if params[:search]
        @un_locals = UnLocal.search(params[:search]).order("created_at DESC")
      else
        @un_locals = UnLocal.all.order('created_at DESC')
      end
    end

    #**************************
    # Show
    #**************************
    def show
      @un_local = UnLocal.find(params[:id])

      # Permet d'afficher la liste des services dans la page du Local
      @services = Service.where(activated: true).paginate(page: params[:page])

      # Permet d'afficher l'information complet d'un Point de Service associé au Local
      @point_of_services = PointOfService.where(activated: true).paginate(page: params[:page])
    
    # Permet de recuperer le nombre d'objets du Local possede
    qte_services
  end

    #**************************
    # Quantité Objets
    #**************************
    def qte_services

      # Permet d'afficher le nombre d'organisme referent que possede l'organisme
      @vosservices = @un_local.follows_by_type('Service').count
    end 

    #**************************
    # New
    #**************************
    def new
      @un_local = UnLocal.new
    end

    #**************************
    # Create
    #**************************
    def create

      @un_local = UnLocal.new(un_local_params)

      # Si l'utilisateur confirme la creation d'un local
      if @un_local.save
        @point_of_service = PointOfService.find_by(id: @un_local.point_of_services_id)

        # Si l'ID entré n'es associé à aucun point de service et que la case n'est pas vide
        if @point_of_service == nil && @un_local.point_of_services_id != nil
          flash[:danger] = "Il n'existe pas de Point de Service avec l'ID #{@un_local.point_of_services_id}"
          render 'new'
        else

          # Si un ID Point de Service a été entré, On ajoute un Local au Point de service
          if @un_local.point_of_services_id != nil
           @point_of_service.follow(@un_local)
          end 

          flash[:success] = "Local créé"
          redirect_to @un_local
        end
      else
        render 'new'
      end
    end

    #**************************
    # Edit
    #**************************
    def edit
      @un_local = UnLocal.find(params[:id])
    end

    #**************************
    # Update
    #**************************
    def update

      @un_local = UnLocal.find(params[:id])

      # Si le Local est deja associé à un Point de Service
      if @un_local.point_of_services_id != nil
        @point_of_service_actuel = PointOfService.find_by(id: @un_local.point_of_services_id)
      end  
     
     # Si on procede a la mise a jour du local
      if @un_local.update_attributes(un_local_params)
        @point_of_service = PointOfService.find_by(id: @un_local.point_of_services_id)

        # Si l'ID n'est associé avec aucuns Point de Services de la base de donnee et que la case n'est pas vide
        if @point_of_service == nil && @un_local.point_of_services_id != nil
          flash[:danger] = "Il n'existe pas de point de service avec l'ID #{@un_local.point_of_services_id}"
          redirect_to edit_un_local_path
        else 

          # Si un ID Point de service a été entré pour creer une association
          if @un_local.point_of_services_id != nil

            # Si l'ID Point de Service a été changé pour être associé à un autre Point de Service
            if @point_of_service_actuel != @point_of_service && @point_of_service != nil
               @point_of_service_actuel.stop_following(@un_local)
            end

            # On ajoute un Local au Point de Service
            @point_of_service.follow(@un_local)

          # Si la case ID Point de Service a été effacée et laissée vide, on retire le Local du Point de Service 
          elsif @un_local.point_of_services_id == nil 
            @point_of_service_actuel.stop_following(@un_local)
          end

          flash[:success] = "Local mis à jour"
          redirect_to current_un_local
        end
      else
        render 'edit'
      end
    end

    #**************************
    # Destroy
    #**************************
    def destroy

      # Supression du local
      UnLocal.find(params[:id]).destroy
      flash[:success] = "Local supprimé"
      redirect_to un_locals_path
    end

    #*****************************************
    # Ajouter ou Retirer Service
    #*****************************************
    def ajouter_retirer_service
      @un_local = UnLocal.find(params[:id])
      @services = Service.where(activated: true).paginate(page: params[:page])
    end 

    #**************************
    # Ajouter service au Local
    #**************************
    def ajouter

      @un_local = UnLocal.find(params[:un_local_id])   
      @service = Service.find(params[:service_id])

      # Si on souhaite ajouter un service et qu'il est deja avec un autre Local
      if @service.un_locals_id != nil

        # On retire le service actuel pour permettre un nouvel ajout a un autre Local
        @un_local = UnLocal.find_by(id: @service.un_locals_id)
        @un_local.stop_following(@service)
      end  

      # On associe le service avec le Local et on met a jour le ID
      @un_local = UnLocal.find(params[:un_local_id]) 
      @un_local.follow(@service)
      @service.update_column(:un_locals_id, current_un_local.id)

      flash[:success] = "Vous avez ajouté le service #{@service.nom} au local #{@un_local.nom}"
      redirect_to ajouter_retirer_service_un_local_path(@un_local)
    end

    #**************************
    # Retirer service du Local
    #**************************
    def retirer
      @un_local = UnLocal.find(params[:un_local_id])   
      @service = Service.find(params[:service_id])

      # On defait l'association entre service et un Local
      @un_local.stop_following(@service)
      @service.update_column(:un_locals_id, nil)

      flash[:warning] = "Vous avez retiré le service #{@service.nom} du local #{@un_local.nom}"
      redirect_to ajouter_retirer_service_un_local_path(@un_local)
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
    # Parametre Local
    #**************************
    def un_local_params
      params.require(:un_local).permit(:nom, :qte_places, :est_disponible, :activated_at, :activated, :point_of_services_id)
    end
  end