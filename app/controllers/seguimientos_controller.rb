class SeguimientosController < ApplicationController
  require_role [:convenios, :direccion, :subdireccion]
  
  def index
    @tramites = Tramite.find(:all, :conditions => ["folio_expediente IS NOT NULL"], :order => "anio DESC, folio_expediente DESC")
    @tramites ||= Array.new
    if current_user.has_role?(:convenios)
        @tramites = Tramite.find(:all, :select => "t.*", :joins => "t, convenios c", :conditions => "t.id=c.tramite_id", :group => "t.id")
        @title = "Seguimiento de convenios"
    end
    @title ||= "Seguimiento de expedientes"
    @tramites = @tramites.paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "kolaval"
  end


  ##################################################
  #
  #           BITACORA DE SEGUIMIENTO DE CONVENIOS
  #
  ##################################################

  def bitacora
    if params[:fecha_inicio] && params[:fecha_fin]
      params[:fecha_fin] = (params[:fecha_inicio]==params[:fecha_fin]) ? params[:fecha_fin] + " 23:59" : params[:fecha_fin]
      @inicio, @fin = DateTime.parse(params[:fecha_inicio]), DateTime.parse(params[:fecha_fin] + " 23:59")
      @seguimientos = Seguimiento.find(:all, :conditions => ["fechahora between ? AND ? ", @inicio, @fin]).paginate(:page => params[:page], :per_page => 25)
    else
      @seguimientos = Array.new
    end
    render :partial => "bitacora", :layout => "kolaval"
  end


  def list_by_convenio
    @convenio = Convenio.find(params[:c]) if params[:c]
    @seguimientos = Seguimiento.find(:all, :conditions => ["convenio_id = ?", @convenio]).paginate(:page => params[:page], :per_page => 25)
    if @seguimientos.empty?
      redirect_to :action => "new_or_edit", :c => @convenio
    else
      render :partial => "list_by_convenio", :layout => "kolaval"
    end
  end

  def search
    @tramites = Tramite.search(params[:search], 'convenios').paginate(:page => params[:page], :per_page => 25)
    render :partial => "list", :layout => "kolaval"
  end

  def new_or_edit
    @seguimiento = Seguimiento.find(params[:id]) if params[:id]
    @seguimiento ||= Seguimiento.new
    @convenio = Convenio.find(params[:c]) if params[:c]
    @convenio ||= @seguimiento.convenio
    @manifestaciones = ManifestacionSeguimiento.all
    @participantes = (@convenio.tramite && @convenio.tramite.comparecencia)? @convenio.tramite.comparecencia.participantes : Array.new if @convenio
    @participantes ||= Array.new
    @participante = @seguimiento.participante
    if @participantes.empty?
      flash[:error] = "No existen participantes asociados a la comparecencia, capturelos e ingrese de nuevo"
      redirect_to :action => "list_by_convenio", :c => @convenio
    end
  end

  def save
    @seguimiento = Seguimiento.find(params[:id]) if params[:id]
    @seguimiento ||= Seguimiento.new
    @seguimiento.update_attributes(params[:seguimiento])
    @convenio = Convenio.find(params[:c]) if params[:c]
    @seguimiento.convenio = @convenio
    @seguimiento.user = current_user
    if @seguimiento.save
      flash[:notice] = "Seguimiento guardado correctamente"
      redirect_to :action => "list_by_convenio", :c => @convenio
    else
      flash[:error] = "No pudo guardar correctamente, verifique"
      @convenio = (@seguimiento.convenio_id)? @seguimiento.convenio : Convenio.find(params[:c]) if params[:c]
      @manifestaciones = ManifestacionSeguimiento.all
      @participantes = (@convenio.tramite && @convenio.tramite.comparecencia)? @convenio.tramite.comparecencia.participantes : Array.new
      render :action => "new_or_edit"
    end

  end

  #---------------comentado por el problema de elimniacion-truncate de todos los seguimientos sin explicacion aparente
  #def destroy
  # @seguimiento = Seguimiento.find(params[:id]) if params[:id]
  #  @convenio = Convenio.find(params[:c]) if params[:c]
  #  if @seguimiento.user == current_user || current_user.has_role?(:subdireccion)
  #        if @seguimiento.destroy
  #          flash[:notice] = "Registro eliminado correctamente"
  #        else
  #          flash[:error] = "No tiene privilegios para eliminar el registro"
  #        end
  #        if @convenio
  #          redirect_to :action => "list_by_convenio", :c => @convenio
  #        else
  #          redirect_to :action => "bitacora"
  #        end
  #  end
  #end

  def get_datos_participante
    @participante ||= Participante.new
    if params[:seguimiento_participante_id] && params[:seguimiento_participante_id].size > 0
        if @participante = Participante.find(params[:seguimiento_participante_id])
          return render(:partial => 'datos_personales', :layout => false) if request.xhr?
        else
          render :text => "<b>Participante no encontrado en la base de datos</b>"
        end
    else
           render :text => "<b>Participante no encontrado en la base de datos</b>"
    end
  end
 


end
