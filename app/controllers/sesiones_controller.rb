class SesionesController < ApplicationController
   require_role [:especialistas, :controlagenda]

  def list_by_tramite
    @tramite = Tramite.find(params[:id])
    @sesiones = Sesion.find(:all, :conditions => ["tramite_id = ?", @tramite.id])
  end

  def list_by_user
    if params[:limit] =~ /\d/
      @sesiones_mediador = Sesion.find(:all, :conditions => ["mediador_id = ?", current_user.id], :order => "fecha DESC", :limit => params[:limit])
      @sesiones_comediador = Sesion.find(:all, :conditions => ["comediador_id = ?",current_user.id], :order => "fecha DESC", :limit => params[:limit])
    else
      @sesiones_mediador = Sesion.find(:all, :conditions => ["mediador_id = ?", current_user.id], :order => "fecha DESC")
      @sesiones_comediador = Sesion.find(:all, :conditions => ["comediador_id = ?",current_user.id], :order => "fecha DESC")
    end
  end

  def list_by_fecha
    @fecha = Date.parse(params[:fecha])
    
  end

   def calendario
     @sesiones = Sesion.find(:all, :conditions => ["mediador_id = ? OR comediador_id = ?", current_user.id, current_user.id])
     @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
  end

  def show
    @sesion = Sesion.find(params[:id])
    @token = generate_token
  end

  def new
    @tramite = Tramite.find(params[:id])
    @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
  end

  def save
    @sesion = params[:sesion_id] ? Sesion.find(params[:sesion_id])  :  Sesion.new(params[:sesion])
    @redireccion = params[:sesion_id] ? "list_by_user"  :  "list_by_tramite"
    @sesion.update_attributes(params[:sesion])
    @tramite = Tramite.find(params[:id])
    @sesion.tramite = @tramite
    if @sesion.save
       flash[:notice] = "Sesión guardada correctamente"
       redirect_to :action => @redireccion, :id => @tramite
    else
       flash[:notice] = "no se puedo guardar, verifique"
       render :action => "new"
    end
  end

  def bitacora
    unless (@sesion = Sesion.find(params[:id]))
      redirect_to :action => "list_by_user"
    end
  end

  #######################################################
  #--------- Control y modificacion de sesiones --------
  #######################################################

  def select_schedule
    unless (@sesion = Sesion.find(params[:id]))
      flash[:notice] = "No se pudo encontrar sesion, verifique"
      redirect_to :controller => "home"
    else
      render :partial => 'select_schedule', :layout => 'oficial'
    end
  end


  def edit
    if (@sesion = Sesion.find(params[:id]))
        @tramite = @sesion.tramite
        @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
    else
      flash[:notice] = "No se pudo encontrar sesion, verifique"
      redirect_to :controller => "home"
    end
  end



  def filtro_fecha
    if params[:sesion_fecha]
      @fecha = params[:sesion_fecha]
      @horarios = Horario.find_by_sql(["select * from horarios where id not in (select horario_id  as id from sesions where fecha = ?)",  DateTime.parse(@fecha)])
      #@sesiones = Sesion.find(:all)
      #@date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
      @title = "Resultados encontrados"
      @horarios_disponibles = Horario.find_by_sql(["select * from horarios where id not in (select horario_id  as id from sesions where fecha = ?) and activo=1 group by hora,minutos order by hora,minutos,sala_id", DateTime.parse(@fecha)])
      @salas = Sala.find(:all, :order => "descripcion")
      return render(:partial => 'agenda/horarios_disponibles', :layout => false)
    else
      redirect_to :controller => "agenda", :action => "management"
    end
  end

  def cancel
    if ((@sesion = Sesion.find(params[:id])) && validate_token(params[:t]))
        if current_user.has_role?("controlagenda") || @sesion.user == current_user


          if @sesion.destroy
              flash[:notice] = "Sesión cancelada correctamente, enviando notificación a especialistas.."


              redirect_to :controller => "home"
          else
              flash[:notice] = "No se pudo cancelar, verifique sesión"
              redirect_to :action => "show", :id => @sesion
          end
        end
    elsif params[:id]
        flash[:notice] = "Token de seguridad incorrecto"
        redirect_to :action => "show", :id => params[:id]
    else
        redirect_to :controller => "home"
    end
  end


end
