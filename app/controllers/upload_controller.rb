class UploadController < ApplicationController
  def index
    @tramite = Tramite.find(params[:id])
    @uploaded_files = @tramite.adjuntos
  end

  def new
    @uploaded_file = Adjunto.new
    @tramite = Tramite.find(params[:id]) if params[:id]
  end

  def create
    @uploaded_file =Adjunto.new(params[:adjunto])
    @uploaded_file.tramite = Tramite.find(params[:id]) if params[:id]
    if @uploaded_file.save
      flash[:notice] = "archivo cargado correctamente"
       redirect_to :action => "index", :id => @uploaded_file.tramite
    else
       flash[:notice] = "El archivo no fue cargado correctamente"
       render :action => "new"
    end
   
  end

   def destroy
    @uploaded_file = Adjunto.find(params[:id])
    @tramite = Tramite.find(params[:tramite])
    if @uploaded_file.destroy
      flash[:notice] = "Archivo eliminado correctamente"
    else
      flash[:notice] = "No se puedo eliminar, verifique"
    end
    redirect_to :action => "index", :id => @tramite
   end


  def download
    @uploaded_file  = Adjunto.find(params[:id])
    send_file @uploaded_file.full_path, :type => @uploaded_file.file_type, :disposition => 'inline'
  end

end
