# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

def get_icon_name(estatus)
  case estatus
  when "Activa"
    return "activa.png"
  when "En espera"
    return "en_espera.png"
  when "Finalizado"
    return "finalizado.png"
  else
    return "atender.png"
  end
end

end
