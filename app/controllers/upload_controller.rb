class UploadController < ApplicationController
  require_role [:subdireccion, :especialistas, :direccion, :convenios, :jefeconvenios, :capacitacion]
  
  def index_convenios_all
    @uploaded_files = Adjunto.find(:all, :conditions => ["convenio_id IS NOT NULL"], :order => "created_at DESC").paginate(:page => params[:page], :per_page => 25)
  end

  def index
    @tramite = Tramite.find(params[:id])
    @uploaded_files = @tramite.adjuntos
  end

  def docs_formacion
    @formacion = Formacion.find(params[:id])
    @empleado = @formacion.empleado if @formacion
    @uploaded_files = Adjunto.find(:all, :conditions => ["activo = ? AND formacion_id = ?", true, @formacion.id])
 end

  def new
    if params[:id]
      (params[:token] == "formacion")? @formacion = Formacion.find(params[:id]) : @tramite = Tramite.find(params[:id])
      @uploaded_file = Adjunto.new
    else
      redirect_to :controller => "home"
    end
  end

  def create
    @uploaded_file =Adjunto.new(params[:adjunto])
    (params[:token] == "formacion")? @uploaded_file.formacion = Formacion.find(params[:id]) : @uploaded_file.tramite = Tramite.find(params[:id])
    @ruta = (params[:token] == "formacion")? {:action => "docs_formacion", :id => @uploaded_file.formacion.id} : {:action => "index", :id => @uploaded_file.tramite.id}
    if @uploaded_file.save
      flash[:notice] = "archivo cargado correctamente"
       redirect_to @ruta
    else
       flash[:notice] = "El archivo no fue cargado correctamente"
       render :action => "new"
    end
  end

 ###########################
 #          CONVENIOS                                  #
 ###########################
    
  def new_convenio
    @uploaded_file = Adjunto.new
    @convenio = Convenio.find(params[:id]) if params[:id]
    @especialista = current_user
    return render(:partial => 'new_convenio', :layout => "only_jquery")
  end

  def list_convenios
    @user = current_user
    @convenio = Convenio.find(params[:id]) if params[:id]
    @adjuntos = Adjunto.find(:all, :conditions => ["activo = ? AND convenio_id = ?", true, @convenio])
    @adjunto = Adjunto.new
    unless @adjuntos.empty?
        return render(:partial => 'show_convenios', :layout => "only_jquery")
    else
       @uploaded_file = Adjunto.new
       @user = current_user
       return render(:partial => 'new_convenio', :layout => "only_jquery")
    end
  end

  def create_convenio
    @uploaded_file =Adjunto.new(params[:adjunto])
    @convenio = params[:c] if params[:c]
    @uploaded_file.convenio_id = @convenio
    @uploaded_file.user_id = current_user.id if current_user
    @convenio = Convenio.find(params[:id]) if params[:id]
    @uploaded_file.convenio = @convenio if @convenio
    begin
      if @uploaded_file.valid?
          if @uploaded_file.save
            write_log("Adjunto de Convenio creado correctamente: #{@uploaded_file.inspect}", current_user)
            flash[:notice] = "Evidencia cargada correctamente"
            redirect_to :action => "list_convenios", :id => @convenio
          end
      else
         @errores = @uploaded_file.errors.full_messages
         return render(:partial => 'carga_convenio_error', :layout => "only_jquery")
      end
    rescue ActiveRecord::RecordInvalid => invalid
        @errores = invalid.record.errors.full_messages
        return render(:partial => 'carga_convenio_error', :layout => "only_jquery")
    end
  end

  def destroy_convenio
    if @uploaded_file = Adjunto.find(params[:id])
      @convenio = @uploaded_file.convenio_id
      @adjuntos ||= Array.new
    end
    if (@uploaded_file.user == current_user) && (@uploaded_file.mark_as_deleted)
      write_log("Adjunto de convenio eliminado correctamente: #{@uploaded_file.inspect}", current_user)
      @adjuntos = Adjunto.find(:all, :conditions => ["activo = ? AND convenio_id = ?", true, @convenio]) if @convenio
      flash[:notice] = "Convenio eliminado correctamente"
      return render(:partial => 'show_convenios', :layout => "only_jquery")
    else
      return render(:partial => 'eliminar_convenio_error', :layout => "only_jquery")
    end
  end

  ################################################
  #
  #                           ACCIONES CRUD
  #
  ################################################



   def destroy
      @uploaded_file = Adjunto.find(params[:id])
      flash[:notice] = (@uploaded_file.mark_as_deleted) ?   "Archivo eliminado correctamente" :  "No se puedo eliminar, verifique"
        if params[:token] == "formacion"
            redirect_to :action => "docs_formacion", :id => @uploaded_file.formacion.id
        else
            redirect_to :action => "index", :id => @uploaded_file.tramite.id
        end
   end


  def download
    @uploaded_file  = Adjunto.find(params[:id])
     if File.exists?(@uploaded_file.full_path)
        send_file @uploaded_file.full_path, :type => @uploaded_file.file_type, :disposition => 'inline'
     else
       flash[:error] = "No existe el archivo, contacte al administrador"
       redirect_to(:back)
    end
  end

  def preview_image
    @uploaded_file  = Adjunto.find(params[:id])
    render :partial => "preview_image", :layout => "only_jquery"
  end

  ##### PROFILE PICTURE #####

  def upload_profile_picture
    @empleado = Empleado.find(params[:id])
    @uploaded_file = Adjunto.new
    render :partial => "upload_profile_picture", :layout => "only_jquery"
  end

  def save_profile_picture
    @tipos_validos= ["image/jpeg", "image/jpg", "image/JPG", "image/png"]
    @uploaded_file =Adjunto.new(params[:adjunto])
    @empleado = Empleado.find(params[:id])
    @type_valid = (@tipos_validos.include?(@uploaded_file.file_type))? true : false
    @empleado_valid = (@type_valid && @empleado)? @uploaded_file.empleado = @empleado: nil
    if @empleado_valid && @uploaded_file.save
      render :text => "<h1 style='color: red;'>Imagen cargada correctamente</h1>"
    else
       flash[:error] = "Verifique tipo de archivo, no fue cargado correctamente, "
       redirect_to :action => "upload_profile_picture", :id => @empleado
    end
  end

  def destroy_profile_picture
    @uploaded_file = Adjunto.find(params[:id])
    @empleado = Empleado.find(params[:empleado])
    flash[:notice] = (@uploaded_file.destroy) ? "Foto eliminada correctamente" : "No se pudo eliminar, verifica"
    redirect_to :action => "show", :controller => "empleados", :id => @empleado
  end

end
