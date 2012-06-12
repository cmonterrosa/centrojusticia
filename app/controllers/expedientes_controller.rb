class ExpedientesController < ApplicationController
  def index
  end

  def asignar_materia
    @expediente = Expediente.new
    @comparecencia = Comparecencia.find(params[:id])
  end

  def save
      @expediente = Expediente.new(params[:expediente])
      @expediente.user = current_user
      @expediente.anio = params[:expediente]["fechahora(1i)"].to_i
      @expediente.folio = generar_folio(@expediente.anio)
      @expediente.comparecencia = Comparecencia.find(params[:id])
      if @expediente.save
        flash[:notice] = "Registro guardado correctamente"
        redirect_to :action => "list_by_user", :controller => "orientacions"
      else
        flash[:notice] = "no se pudo guardar el registro, verifique"
        render :action => "asignar_materia"
      end
  end

  def generar_folio(anio)
    maximo=  Expediente.maximum(:folio, :conditions => ["anio = ?", anio])
    folio = 1 unless maximo
    folio ||= maximo+1
  end

end
