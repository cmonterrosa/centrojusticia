class SesionesController < ApplicationController
  def list_by_tramite
    @tramite = Tramite.find(params[:id])
    @sesiones = Sesion.find(:all, :conditions => ["tramite_id = ?", @tramite.id])
  end

  def list_by_user
    if params[:limit] =~ /\d/
      @sesiones_mediador = Sesion.find(:all, :conditions => ["mediador_id = ?", current_user.id], :order => "start_at DESC", :limit => params[:limit])
      @sesiones_comediador = Sesion.find(:all, :conditions => ["comediador_id = ?",current_user.id], :order => "start_at DESC", :limit => params[:limit])
    else
      @sesiones_mediador = Sesion.find(:all, :conditions => ["mediador_id = ?", current_user.id], :order => "start_at DESC")
      @sesiones_comediador = Sesion.find(:all, :conditions => ["comediador_id = ?",current_user.id], :order => "start_at DESC")
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

  def change_schedule
    if (@sesion = Sesion.find(params[:id]))
        @tramite = @sesion.tramite
        @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
    else
      flash[:notice] = "No se pudo encontrar sesion, verifique"
      redirect_to :controller => "home"
    end
  end

  def filtro_fecha
    redirect_to :action => "search_sesiones", :controller => "agenda", :fecha => params[:sesion_fecha]
  end


end
