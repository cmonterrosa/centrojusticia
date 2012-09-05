class CustomsController < ApplicationController

  def index
    @usuario=current_user
    if @usuario.has_role?(:admin)
        return render(:partial => 'admin', :layout => "oficial")
    elsif @usuario.has_role?(:direccion)
        return render(:partial => 'direccion', :layout => "oficial")
    elsif @usuario.has_role?(:subdireccion)
        return render(:partial => 'subdireccion', :layout => "oficial")
    elsif @usuario.has_role?(:especialistas)
        return render(:partial => 'especialistas', :layout => "oficial")
    elsif @usuario.has_role?(:controlagenda)
        return render(:partial => 'controlagenda', :layout => 'oficial')
    elsif @usuario.has_role?(:invitadores)
        return render(:partial => 'invitadores', :layout => "oficial")
    else
        return render(:partial => 'publico_general', :layout => "oficial")
    end
  end

  def profile
    @usuario = current_user
  end

  def management
    redirect_to :action => "show_calendario"
  end

  def show_calendario
     @sesion = Sesion.new
     @sesiones = (params[:id] == "all") ? Sesion.find(:all, :select=> ["s.*"], :joins => "s, horarios h", :conditions => ["s.horario_id=h.id"], :order => "s.fecha, h.hora,h.minutos") :  Sesion.find(:all, :conditions => ["fecha is not NULL and (mediador_id = ? OR comediador_id = ?)", current_user.id, current_user.id], :order => "fecha")
     @title = (params[:id] == "all") ? "Calendario general": "Calendario personalizado para #{current_user.nombre_completo}"
     @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
  end


  #----- Manejo de sesiones ---
  def search_sesiones
    if params[:sesion]
      @fecha = params[:sesion][:fecha] if params[:sesion][:fecha]
      @horarios = Horario.find_by_sql(["select * from horarios where id not in (select horario_id  as id from sesions where fecha = ?)",  DateTime.parse(@fecha)])
      @sesiones = Sesion.find(:all, :conditions => ["fecha is not NULL and (mediador_id = ? OR comediador_id = ?)", current_user.id, current_user.id], :order => "fecha")
      @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
      @title = "Resultados encontrados"
      @horarios_disponibles = Horario.find_by_sql(["select * from horarios where id not in (select horario_id  as id from sesions where fecha = ?) and activo=1 group by hora,minutos order by hora,minutos,sala_id", DateTime.parse(@fecha)])
      @salas = Sala.find(:all, :order => "descripcion")
    else
      redirect_to :action => "show_calendario"
    end
  end
  

end
