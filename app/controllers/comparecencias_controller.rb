class ComparecenciasController < ApplicationController

  def new_or_edit
    @comparecencia = Comparecencia.find(:first, :conditions => ["orientacion_id = ?", params[:id]])
    @comparecencia ||= Comparecencia.create
    @comparecencia.orientacion ||= Orientacion.find(params[:id])
    @dias = {'Lunes' => 1, 'Martes' => 2, 'Miercoles' => 3, 'Jueves' => 4, 'Viernes' => 5, 'Sábados' => 6}
  end

  def save
    @orientacion = Orientacion.find(params[:orientacion])
    if @orientacion.comparecencia
       @comparecencia= @orientacion.comparecencia
       @comparecencia.update_attributes(params[:comparecencia])
    else
      @comparecencia = Comparecencia.new(params[:comparecencia])
      @comparecencia.orientacion = @orientacion
    end
    @comparecencia.user = current_user
    if @comparecencia.save
      flash[:notice] = "Guardado correctamente"
      redirect_to :controller => "orientacions", :action => "list_by_user"
    else
      flash[:notice] = "No se pudo guardar, verifique"
      render :action => "new_or_edit"
    end
  end

end
