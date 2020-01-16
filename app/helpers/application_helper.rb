#**************************************************************
# SUPPORT APPLICATION
#**************************************************************
module ApplicationHelper

  #**************************
  # Retourne titre page
  #**************************
  def full_title(page_title = '')
    base_title = "Portail RQRSDA"

    # S'assure que chaque page porte un titre
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
