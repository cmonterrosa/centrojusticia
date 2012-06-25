class ExpedientesController < ApplicationController
  def index
  end

  def asignar_materia
    @expediente = Comparecencia.find(params[:id]).expediente
    @expediente ||= Expediente.new
    @comparecencia = Comparecencia.find(params[:id])
  end

  def save
      #---- Si existe registro previo ---
      @comparecencia = Comparecencia.find(params[:id])
      @expediente = @comparecencia.expediente
      @expediente.update_attributes(params[:expediente]) if @expediente
      #--- creamos nuevo objeto -----
      @expediente ||= Expediente.new(params[:expediente])
      #----- establecemos parametros de control ---
      @expediente.user = current_user
      @expediente.anio = params[:expediente]["fechahora(1i)"].to_i
      @expediente.folio = generar_folio(@expediente.anio) unless @expediente.folio
      @expediente.comparecencia = @comparecencia
      if @expediente.save
        flash[:notice] = "Registro guardado correctamente"
        redirect_to :action => "list_by_user", :controller => "orientacions"
      else
        flash[:notice] = "no se pudo guardar el registro, verifique"
        render :action => "asignar_materia"
      end
  end

  def validar
    render :text => "Validando"
  end


protected
  def generar_folio(anio)
    maximo=  Expediente.maximum(:folio, :conditions => ["anio = ?", anio])
    folio = 1 unless maximo
    folio ||= maximo+1
  end

end
