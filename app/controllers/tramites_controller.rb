class TramitesController < ApplicationController
  def index
  end

  def list
    @tramites = Tramite.find(:all, :order => "created_at DESC")
  end

  def show
    unless @tramite=Tramite.find(params[:id])
      flash[:notice] = "No se encontro trámite, verifique"
      redirect_back_or_default('/')
    end
  end

  def asignar_materia
    @expediente = Comparecencia.find(params[:id]).expediente
    @expediente ||= Tramite.new
    @comparecencia = Comparecencia.find(params[:id])
  end

  def save
      #---- Si existe registro previo ---
      @comparecencia = Comparecencia.find(params[:id])
      @expediente = @comparecencia.expediente
      @expediente.update_attributes(params[:expediente]) if @expediente
      #--- creamos nuevo objeto -----
      @expediente ||= Tramite.new(params[:expediente])
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

  def search
    if params[:q] && params[:q] =~ /\d+/
      if @tramite = Tramite.find(:first, :conditions => ["id = ? or folio = ?", params[:q], params[:q]])
         redirect_to :action => "show", :id => @tramite
      else
         flash[:notice] = "No se encontraron resultados, verifique"
         redirect_back_or_default('/')
      end
    else
      flash[:notice] = "No se pudo realizar la búsqueda, verifique"
      redirect_back_or_default('/')
    end
  end

   #----- filtros ajax --------
  def filtro_estatus
    if params[:estatu_id].size > 0
      @estatu = Estatu.find(params[:estatu_id])
      @tramites = Tramite.find(:all, :conditions => ["estatu_id = ?", @estatu.id], :order => "created_at DESC") if @estatu
    end
    @tramites ||= Tramite.find(:all, :order => "created_at DESC")
    return render(:partial => 'listajax', :layout => false) if request.xhr?
  end

protected
  def generar_folio(anio)
    maximo=  Tramite.maximum(:folio, :conditions => ["anio = ?", anio])
    folio = 1 unless maximo
    folio ||= maximo+1
  end

end
