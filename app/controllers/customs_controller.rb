class CustomsController < ApplicationController

  def index
    @usuario=current_user
    if @usuario.has_role?(:direccion)
        return render(:partial => 'direccion', :layout => "oficial")
    elsif @usuario.has_role?(:subdireccion)
        return render(:partial => 'subdireccion', :layout => "oficial")
    elsif @usuario.has_role?(:especialistas)
        return render(:partial => 'especialistas', :layout => "oficial")
    elsif @usuario.has_role?(:invitadores)
        return render(:partial => 'invitadores', :layout => "oficial")
    else
        return render(:partial => 'publico_general', :layout => "oficial")
    end
  end

  def profile
    @usuario = current_user
  end


  def calendario
     @sesiones = Sesion.find(:all, :conditions => ["start_at is not NULL"], :order => "start_at")
     @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
     @title = "Calendario personalizado para #{current_user.nombre_completo}"
     return render(:partial => 'agenda/calendario', :layout => "oficial")
  end

end
