#**************************************************************
# CONTROLEUR SERVICES
#**************************************************************
require 'openssl'
class ServicesController < ApplicationController

  #**************************
  # Liste des Services
  #**************************
  def index
    @services = Service.where(activated: true).paginate(page: params[:page])

    # Si la recherche est lancee
    if params[:search]
      @services = Service.search(params[:search]).order("created_at DESC")
    else
      @services = Service.all.order('created_at DESC')
    end
  end

  #**************************
  # Affiche Info Service
  #**************************
  def show

    # Affiche le service et le local associé
    @service = Service.find(params[:id])
    @un_locals = UnLocal.where(activated: true).paginate(page: params[:page])

    # Mise a jour de la Tarification
    update_tarification
  end

  #**************************
  # Mise a Jour Tarification
  #**************************
  def update_tarification

    # Si la date de tarification d'entree en vigueur et celle d'aujourd'hui
    if @service.date_entree_vigueur == Date.today

      # On met a jour les columns avec la l'information entrée antérieurement
      @service.update_column(:tarification_parent, :futur_tarification_parent)  
      @service.update_column(:tarification_cisss, :futur_tarification_cisss)  
      @service.update_column(:est_subventionnee, :sera_subventionnee)  
    end    
  end  

  #**************************
  # Nouveau Service
  #**************************
  def new
    @service = Service.new
  end

  #**************************
  # Creer Service
  #**************************
  def create

    @service = Service.new(service_params)

    # Confirme la creation d'un service
    if @service.save
      @un_local = UnLocal.find_by(id: @service.un_locals_id)

       # Si l'ID entré n'est associé à aucun Local et la case n'est pas vide
      if @un_local == nil && @service.un_locals_id != nil     
        flash[:danger] = "Il n'existe pas de Local avec l'ID #{@service.un_locals_id}"
        render 'new'
      else

        # Si un ID Local a été entré, on ajoute un service au Local
        if @service.un_locals_id != nil
          @un_local.follow(@service)
        end
         
        flash[:success] = "Service créé"
        redirect_to @service
      end
    else
      render 'new'
    end
  end

  #**************************
  # Modifier Service
  #**************************
  def edit
    @service = Service.find(params[:id])
  end

  #**************************
  # Mettre a Jour Service
  #**************************
  def update
    @service = Service.find(params[:id])
    @tarif_cisss_actuel = @service.tarification_cisss
    @tarif_parent_actuel = @service.tarification_parent

    # Si le Service est deja associé à un Local
    if @service.un_locals_id != nil
      @un_local_actuel = UnLocal.find_by(id: @service.un_locals_id)
    end 

    # Si on procede a la mise a jour du Service
    if @service.update_attributes(service_params)
        @un_local = UnLocal.find_by(id: @service.un_locals_id)

        # Si l'ID n'est associé avec aucuns Local de la base de donnee et que la case n'est pas vide
        if @un_local == nil && @service.un_locals_id != nil
          flash[:danger] = "Il n'existe pas de Local avec l'ID #{@service.un_locals_id}"
          redirect_to edit_service_path

        elsif @service.date_entree_vigueur != nil && @service.date_entree_vigueur < Date.today
            flash[:danger] = "La Date d'Entree en Vigueur ne peut pas être inférieur à la date actuelle"
            redirect_to edit_service_path

        elsif (@tarif_cisss_actuel != @service.tarification_cisss || @tarif_parent_actuel != @service.tarification_parent) && @service.date_entree_vigueur == nil
            flash[:danger] = "Vous devez absolument entrer une Date de Tarification d' Entree en Vigueur"
            redirect_to edit_service_path
        else 

          # Si l'ID Local a été changé pour être associé à un autre Local
          if @service.un_locals_id != nil
            if @un_local_actuel != @un_local && @un_local_actuel != nil
               @un_local_actuel.stop_following(@service)
            end

            # On ajoute le Service au Local 
            @un_local.follow(@service)

          # Si la case ID Local a été effacée et laissée vide, on retire le Service du Local
          elsif @service.un_locals_id == nil && @un_local_actuel != nil
            @un_local_actuel.stop_following(@service)
          end  
  
        flash[:success] = "Service mis à jour"
        redirect_to current_service
      end
    else
      render 'edit'
    end
  end

  #**************************
  # Supprimer Service
  #**************************
  def destroy

    # Supression du service
    Service.find(params[:id]).destroy
    flash[:success] = "Service supprimé"
    redirect_to services_path
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


  #**************************
  # Ajouter (usage futur)
  #**************************
  def ajouter
  end

  #**************************
  # Retirer (usage futur)
  #**************************
  def retirer
  end

  private

  #**************************
  # Parametre Services
  #**************************
  def service_params
    params.require(:service).permit(:nom, :description, :tarification_parent, :tarification_cisss,:est_actif, :est_subventionnee, 
      :date_entree_vigueur, :futur_tarification_cisss, :futur_tarification_parent, :sera_subventionnee, :un_locals_id)
  end
end
