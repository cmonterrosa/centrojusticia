class AtencionController < ApplicationController
  require_role [:atencionpublico, :subdireccion, :direccion, :oficinasubdireccion]
 
  def index
    
  end

  def info
    @title = "Index Page"
    @client_ip = request.remote_ip
    @remote_ip = request.env["HTTP_X_FORWARDED_FOR"]
    @my_ip = request.env["HTTP_X_FORWARDED_FOR"] || request.remote_addr
    @ip_addr = request.env['REMOTE_ADDR']
  end


  ####### ATENCION POR ESCRITO #########
  def por_escrito_index
      #@tramites_por_escrito = Atencion.find_by_descripcion("POR ESCRITO").tramites.paginate(:page => params[:page], :per_page => 15)
      @tramites_por_escrito = Tramite.find(:all, :conditions => ["atencion_id = ?", Atencion.find_by_descripcion("POR ESCRITO").id], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 15)
  end


  def por_escrito_new_or_edit
    new_atencion
  end

  def por_escrito_save
    @tipo_atencion = Atencion.find_by_descripcion("POR ESCRITO")
    @estatus_nuevo = "tram-escr"
    save
  end

  ################# POR TELEFONO  #####################

  def por_telefono_index
      @tramites_por_telefono = Atencion.find_by_descripcion("POR TELEFONO").tramites
  end

  def por_telefono_new_or_edit
    new_atencion
  end

  def por_telefono_save
   @tipo_atencion = Atencion.find_by_descripcion("POR TELEFONO")
   @estatus_nuevo = "tram-tele"
   save
  end



  ###### POR CORREO ##############

  def por_correo_index
      @tramites_por_telefono = Atencion.find_by_descripcion("POR CORREO ELECTRONICO").tramites
  end

  def por_correo_new_or_edit
    new_atencion
  end

  def por_correo_save
   @tipo_atencion = Atencion.find_by_descripcion("POR CORREO ELECTRONICO")
   @estatus_nuevo = "tram-corr"
   save
  end

  ### FUNCIONES COMPARTIDAS ###

  def save
    @orientacion = Orientacion.find(:first, :conditions => ["id = ?", params[:id]]) if params[:id]
    (@orientacion) ? @orientacion.update_attributes(params[:orientacion]) : @orientacion = Orientacion.new(params[:orientacion])
    @tramite = (@orientacion.tramite) ? @orientacion.tramite : Tramite.new
    @tramite.anio = params[:orientacion][:fechahora].split("/")[0] if params[:orientacion][:fechahora]
    @tramite.anio ||= Time.now.year
    @tramite.generar_folio unless @tramite.folio
    @tramite.subdireccion_id = current_user.subdireccion_id unless @tramite.subdireccion
    @orientacion.user, @tramite.user= current_user, current_user
    @orientacion.tramite ||= @tramite
    @orientacion.fechahora ||= Time.now
    @tramite.fechahora = @orientacion.fechahora
    @tramite.atencion = @tipo_atencion if @tipo_atencion
    if  @orientacion.save && @tramite.save
       @tramite.update_estatus!(@estatus_nuevo, current_user)
       flash[:notice] = "Captura de comparecencia"
       redirect_to :controller => "comparecencias", :action => "new_or_edit", :id => @tramite
    else
      flash[:notice] = "No se pudo guardar, verifique"
      render :action => "new_or_edit"
    end
  end

  def new_atencion
    @orientacion = Orientacion.find(:first, :conditions => ["tramite_id = ?", params[:id]]) if params[:id]
    @orientacion ||= Orientacion.new
  end


end
