class UploadController < ApplicationController
  def index
    @tramite = Tramite.find(params[:id])
    @uploaded_files = @tramite.adjuntos
  end

  def docs_formacion
    @formacion = Formacion.find(params[:id])
    @empleado = @formacion.empleado if @formacion
    @uploaded_files = @formacion.adjuntos
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

   def destroy
      @uploaded_file = Adjunto.find(params[:id])
      flash[:notice] = (@uploaded_file.destroy) ?   "Archivo eliminado correctamente" :  "No se puedo eliminar, verifique"
        if params[:token] == "formacion"
            redirect_to :action => "docs_formacion", :id => @uploaded_file.formacion.id
        else
            redirect_to :action => "index", :id => @uploaded_file.tramite.id
        end
   end


  def download
    @uploaded_file  = Adjunto.find(params[:id])
    send_file @uploaded_file.full_path, :type => @uploaded_file.file_type, :disposition => 'inline'
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
