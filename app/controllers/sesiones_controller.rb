
class SesionesController < ApplicationController
  def list_by_tramite
    @tramite = Tramite.find(params[:id])
    @sesiones = Sesion.find(:all, :conditions => ["tramite_id = ?", @tramite.id])
  end

  def list_by_user
    @sesiones_mediador = Sesion.find(:all, :conditions => ["mediador_id = ?", current_user.id])
    @sesiones_comediador = Sesion.find(:all, :conditions => ["comediador_id = ?",current_user.id])
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
    @sesion=Sesion.new(params[:sesion])
    @tramite = Tramite.find(params[:id])
    @sesion.tramite = @tramite
    if @sesion.save
       flash[:notice] = "Sesión guardada correctamente"
       redirect_to :action => "list_by_tramite", :id => @tramite
    else
       flash[:notice] = "no se puedo guardar, verifique"
       render :action => "new"
    end
  end


end
