class ExtraordinariaController < ApplicationController
     require_role [:direccion,:admindireccion,:oficinasubdireccion]
     require_role :admin, :only => [:destroy]

    def index
      @extraordinarias = Extraordinaria.find(:all, :order => "fechahora DESC")
    end

    def new_or_edit
      @extraordinaria = Extraordinaria.find(:first, :conditions => ["tramite_id = ?", params[:id]]) if params[:id]
      @extraordinaria ||= Extraordinaria.new
      @procedencias = Procedencia.find(:all, :order => "descripcion")
      @especialistas = Role.find_by_name("especialistas").users.sort{|p1,p2|p1.nombre_completo <=> p2.nombre_completo}
    end

    def save
    #--- Iniciamos trámite --
    @extraordinaria = Extraordinaria.find(:first, :conditions => ["id = ?", params[:id]]) if params[:id]
    (@extraordinaria) ? @extraordinaria.update_attributes(params[:extraordinaria]) : @extraordinaria = Extraordinaria.new(params[:extraordinaria])
    @tramite = (@extraordinaria.tramite) ? @extraordinaria.tramite : Tramite.new
    @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
    @tramite.anio = params[:extraordinaria][:fechahora].split("/")[0] if params[:extraordinaria][:fechahora]
    @tramite.anio ||= Time.now.year
    @tramite.generar_folio unless @tramite.folio
    @tramite.subdireccion_id = current_user.subdireccion_id unless @tramite.subdireccion
    @tramite.user= current_user
    @extraordinaria.user = current_user
    @extraordinaria.fechahora ||= Time.now
    @tramite.fechahora = @extraordinaria.fechahora
    @extraordinaria.tramite = @tramite
    @extraordinaria.especialista_id = User.find(params[:extraordinaria][:user_id]).id if params[:extraordinaria][:user_id] && params[:extraordinaria][:user_id].size > 0
      ####### Si se tecleo numero de expediente ############
      if @extraordinaria.num_expediente =~ /^\d{1,4}\/\d{4}$/
          ### checamos si existe ###
          folio,anio = @extraordinaria.num_expediente.split("/")
          @exists_tramite = Tramite.find(:first, :conditions => ["anio = ? AND folio_expediente = ?", anio, folio])
          if @exists_tramite
             @extraordinaria.tramite = @exists_tramite
             @tramite.update_attributes!(:anio => anio, :folio => folio)
             @save_num_expediente = false
          end
        else
           @tramite.generar_folio_expediente!
           @save_num_expediente = true
      end

      #### Guardamos registro #####
      msj = (@save_num_expediente)? "Guardado correctamente" : "Ya existe en el sistema"
      if @extraordinaria.save && @tramite.save
              @tramite.update_estatus!("tram-extr", current_user)
              if @extraordinaria.notificacion
                  NotificationsMailer.deliver_tramite_created(@tramite, @extra.especialista) #sends the email
                  flash[:notice] = "Expediente: #{@tramite.numero_expediente} #{msj} y envío de notificación por email"
              else
                  flash[:notice] = "Expediente: #{@tramite.numero_expediente} #{msj}, sin envío de notificación por email"
              end
              redirect_to :controller => "extraordinaria"
          else
              flash[:notice] = "No se pudo guardar, verifique"
              render :action => "new_or_edit"
      end
      
     
  end

    def destroy
    @tramite = Tramite.find(params[:id])
    @extraordinaria = Extraordinaria.find_by_tramite_id(params[:id])
    @historico = Historia.find_by_tramite_id(params[:id])
    if @extraordinaria.destroy && @historico.destroy && @tramite.destroy
      flash[:notice] = "Registro eliminado correctamente"
    else
      flash[:notice] = "No se pudo eliminar, verifique"
    end
    redirect_to :action => "index"
  end

  def show
    unless @extraordinaria=Extraordinaria.find(params[:id])
      flash[:notice] = "No se encontro trámite, verifique"
      redirect_back_or_default('/')
    end
  end

end
