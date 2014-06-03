class ConfiguracionController < ApplicationController

  def index
    redirect_to :action => "new_or_edit"
  end

  def new_or_edit
    max_id = Configuracion.maximum(:id)
    @configuracion = Configuracion.find(max_id) if Configuracion.exists?(max_id)
    @configuracion ||= Configuracion.new
  end

  def update
    @configuracion = Configuracion.find(1) if Configuracion.exists?(1)
    @configuracion ||= Configuracion.new
    @configuracion.update_attributes(params[:configuracion])
    if @configuracion.save
      flash[:notice] = "Configuración actualizada correctamente"
      redirect_to :action => "index", :controller => "admin"
    else
      flash[:error] = "No se pudo guardar, verifique"
      render :action => "new_or_edit"
    end
  end
end
