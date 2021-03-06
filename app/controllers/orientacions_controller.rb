require 'date'
class OrientacionsController < ApplicationController
  require_role [:atencionpublico, :subdireccion, :direccion], :for => [:new_or_edit, :save]
  require_role [:especialistas, :convenios], :for => [:list_by_user]
  require_role [:admin, :admindireccion, :direccion], :for => [:show_especialistas_disponibles]

  def index
   
  end

  def list_by_user
    @user = current_user
    #@estatus = Estatu.find_by_clave("tram-inic")
    #@estatuses = Estatu.find(:all, :conditions => ["clave in (?)", ['tram-inic', 'tram-reas']])

    if (params[:type] == "all")
       @orientaciones = Orientacion.find(:all,
                                       :select => "o.*",
                                       :joins => "o, tramites t, estatus e",
                                       :conditions => ["o.tramite_id = t.id AND o.especialista_id = ? AND t.estatu_id=e.id AND e.clave IN (?)", @user.id, ['tram-reas', 'tram-inic', 'orie-conf']],
                                       :order => "o.fechahora")
    else
       @orientaciones = Orientacion.find(:all,
                                       :select => "o.*",
                                       :joins => "o, tramites t, estatus e",
                                       :conditions => ["o.tramite_id = t.id AND o.especialista_id = ? AND t.estatu_id=e.id AND e.clave IN (?) AND o.created_at > ? ", @user.id, ['tram-reas', 'tram-inic', 'orie-conf'], "#{(Time.now - (10080 * 60.0)).strftime('%Y-%m-%d %H:%M:%S')}" ],
                                       :order => "o.fechahora")
    end
  end

  def list_all
    @orientaciones = Orientacion.find(:all, :order => "fechahora")
    @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
  end

  def filtro_especialista
    if params[:user_id].size > 0
      @user = User.find(params[:user_id])
      @orientaciones = Orientacion.find(:all, :conditions => ["user_id = ?", @user.id], :order => "fechahora") if @user
    end
    @orientaciones ||= Orientacion.find(:all, :order => "fechahora")
    return render(:partial => 'list_by_user', :layout => false) if request.xhr?
  end

  def change_estatus
    @orientacion = Orientacion.find(params[:id])
    @orientacion.estatu = Estatu.find_by_descripcion(params[:token])
    flash[:notice] = (@orientacion.save) ? "Estatus de orientación cambiado correctamente" : "No se puedo cambiar estatus, verifique"
    redirect_to :action => "list_by_user"
  end

  def new_or_edit
    #--- If is specialist extra ----
    @extra = true if params[:t] == "extra"
    @orientacion = Orientacion.find(:first, :conditions => ["tramite_id = ?", params[:id]]) if params[:id]
    @orientacion ||= Orientacion.new
    if @extra
      @caption = (@extra) ? "CON PERSONAL EXTRAORDINARIO" : ""
      @caption_type_specialist = (@extra) ? "Extraordinario" : ""
      @especialistas = Role.find_by_name("convenios").users.sort{|p1,p2|p1.nombre_completo <=> p2.nombre_completo}
      @especialista = (!@orientacion.especialista_id.nil?) ? User.find(@orientacion.especialista_id) : nil
    else
      @especialistas = seleccionar_especialistas
      @especialista = (!@orientacion.especialista_id.nil?) ? User.find(@orientacion.especialista_id) : nil
    end
    if current_user.has_role?("direccion")
      @especialistas << current_user
    end

  end


    ############## REASIGNACION DE ORIENTACION ##################

   def reasignar
     @orientacion = Orientacion.find(:first, :conditions => ["tramite_id = ?", params[:id]]) if params[:id]
     #@todos_especialistas = Role.find_by_name("ESPECIALISTAS").usuarios_disponibles.sort{|p1,p2| p1.puntuacion <=> p2.puntuacion}
     @todos_especialistas = seleccionar_especialistas
     @especialista_inicial = @orientacion.especialista
     #@justificaciones = Justificacion.find(:all, :conditions => ["descripcion = ?", "ESPECIALISTA NO DA ATENCIÓN"])
     @justificaciones = Justificacion.find(:all, :conditions => ["descripcion IN (?)", ["ESPECIALISTA NO DA ATENCIÓN", "ESPECIALISTA EN ORIENTACION"]])
     if !@todos_especialistas.empty? && @todos_especialistas.include?(@orientacion.especialista)
      @especialista_nuevo = @todos_especialistas.at(@todos_especialistas.index(@orientacion.especialista) + 1)
       unless @especialista_nuevo
         flash[:notice] = "No existen especialistas disponibles"
         redirect_to :action => "list", :controller => "tramites"
       end
       @historia = Historia.new
     else
       if @todos_especialistas.first
        @especialista_nuevo = @todos_especialistas.first
       else
          flash[:notice] = "No existen especialistas disponibles, intente más tarde"
          redirect_to :action => "list", :controller => "tramites"
       end
     end
   end

   def save_reasignacion
     #@historia = Historia.find(:first, :conditions => ["tramite_id = ?", @orientacion.tramite_id], :order => "created_at DESC")
     @orientacion = Orientacion.find(params[:id])
     @tramite = @orientacion.tramite
     @especialista_inicial = User.find(params[:ei])
     @especialista_nuevo = User.find(params[:en])
     @justificacion = Justificacion.find(params[:historia][:justificacion_id]) if params[:historia][:justificacion_id]
     @justificacion ||= Justificacion.find(:first, :conditions => ["descripcion = ?", "ESPECIALISTA NO DA ATENCIÓN"])
     @orientacion.especialista_id = @especialista_nuevo.id
     if @orientacion.save && @tramite.update_estatus_with_especialista!("tram-reas",current_user,@especialista_inicial,@justificacion)
        flash[:notice] = "Orientación reasignada correctamente"
        redirect_to :action => "index", :controller => "home"
     else
       flash[:notice] = "Ocurrió un error, verifique"
       render :action => "reasignar"
     end
   end



   def save
    #--- Iniciamos trámite --
    @orientacion = Orientacion.find(:first, :conditions => ["id = ?", params[:id]]) if params[:id]
    (@orientacion) ? @orientacion.update_attributes(params[:orientacion]) : @orientacion = Orientacion.new(params[:orientacion])
    @tramite = (@orientacion.tramite) ? @orientacion.tramite : Tramite.new
    @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
    #@tramite.anio = params[:orientacion]["fechahora(1i)"].to_i
    @tramite.anio = params[:orientacion][:fechahora].split("/")[0] if params[:orientacion][:fechahora]
    @tramite.anio ||= Time.now.year
    @tramite.generar_folio unless @tramite.folio
    @tramite.subdireccion_id = current_user.subdireccion_id unless @tramite.subdireccion
    @tramite.user= current_user
    @orientacion.fechahora ||= Time.now
    @tramite.fechahora = @orientacion.fechahora
    @orientacion.tramite = @tramite
    @orientacion.especialista_id = User.find(params[:orientacion][:user_id]).id if params[:orientacion][:user_id]
    #### BUSQUEDA DE ESPECIALISTAS #####
    @especialistas = seleccionar_especialistas
    @orientacion.especialista_id ||= @especialistas.first.id
    if @orientacion.save && @tramite.save
      @tramite.update_estatus!("tram-inic", current_user)
        if @orientacion.notificacion
           NotificationsMailer.deliver_tramite_created(@tramite, @orientacion.especialista) #sends the email
           flash[:notice] = "Guardado correctamente y envío de notificación por email" 
        else
          flash[:notice] = "Guardado correctamente, sin envío de notificación por email"
        end
        redirect_to :controller => "home"
    else
      flash[:notice] = "No se pudo guardar, verifique"
      render :action => "new_or_edit"
    end
   end

   ################# CAPTURA HISTORICA ####################

   def captura_historica
     @orientacion = Orientacion.find(:first, :conditions => ["tramite_id = ?", params[:id]]) if params[:id]
     @orientacion ||= Orientacion.new
     @solo_especialistas = Role.find_by_name("especialistas").users
     @convenios = Role.find_by_name("convenios").users
     @especialistas = (@solo_especialistas +  @convenios).sort{|p1,p2|p1.nombre_completo <=> p2.nombre_completo}
     @especialista = (!@orientacion.especialista_id.nil?) ? User.find(@orientacion.especialista_id) : nil
   end

   def captura_historica_save
    #--- Iniciamos trámite --
    @orientacion = Orientacion.find(:first, :conditions => ["id = ?", params[:id]]) if params[:id]
    (@orientacion) ? @orientacion.update_attributes(params[:orientacion]) : @orientacion = Orientacion.new(params[:orientacion])
    @tramite = (@orientacion.tramite) ? @orientacion.tramite : Tramite.new
    @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
    #@tramite.anio = params[:orientacion]["fechahora(1i)"].to_i
    @tramite.anio = params[:orientacion][:fechahora].split("/")[0] if params[:orientacion][:fechahora]
    @tramite.anio ||= Time.now.year
    @tramite.generar_folio unless @tramite.folio
    @tramite.subdireccion_id = current_user.subdireccion_id unless @tramite.subdireccion
    @tramite.user= current_user
    @orientacion.fechahora ||= Time.now
    @tramite.fechahora = @orientacion.fechahora
    @orientacion.tramite = @tramite
    @orientacion.especialista_id = User.find(params[:orientacion][:user_id]).id if params[:orientacion][:user_id]
    if @orientacion.save && @tramite.save
      @tramite.update_estatus!("tram-inic", current_user)
      @tramite.update_estatus!("no-compar", current_user)
      flash[:notice] = "El solicitante: #{@orientacion.solicitante} guardado correctamente"
      redirect_to :controller => "home"
    else
      flash[:notice] = "No se pudo guardar, verifique"
      render :action => "captura_historica"
    end
   end


   def confirmar
       @tramite = Tramite.find(params[:id])
       @orientacion = Orientacion.find_by_tramite_id(params[:id])
       return render(:partial => 'confirmacion', :layout => "only_jquery")
   end

   def save_confirmar
     ### Verify the user logins and have the role ##########
     @tramite = Tramite.find(params[:tramite])
     if @user = User.find_by_login(params[:login])
        if User.authenticate(params[:login], params[:password]) && (@user.has_role?("especialistas") || @user.has_role?("convenios") || @user.has_role?("direccion"))
            if @tramite
                @orientacion = Orientacion.find_by_tramite_id(@tramite.id)
                @user = User.find_by_login(params[:login])
                @orientacion.especialista_id = @user.id
                @text = (@orientacion.save && @tramite.update_estatus!("orie-conf", current_user)) ? ("Confirmado exitosamente por #{@user.nombre_completo}") : ("No se pudo confirmar, intente de nuevo")
                return render(:partial => 'success_confirmation', :layout => "only_jquery")
            end
        end
     end
     return render(:partial => 'confirmacion', :layout => "only_jquery")
    end

def show_especialistas_disponibles
    @especialistas = seleccionar_especialistas
end



protected

   def seleccionar_especialistas
      norm_date = Date.today
      limite = DateTime.parse("#{Time.now.year}-#{Time.now.month}-#{Time.now.day} 15:55:00")
      ahora = Time.parse("#{norm_date} #{DateTime.now.strftime "%H:%M:%S"}")
      hora_limite = Time.parse("#{norm_date} #{limite.strftime "%H:%M:%S"}")
      especialistas = (ahora >= hora_limite) ? Role.find_by_name("ESPECIALISTAS").usuarios_disponibles_vespertinos : Role.find_by_name("ESPECIALISTAS").usuarios_disponibles
      return (especialistas.sort{|p1,p2| p1.puntuacion <=> p2.puntuacion})
   end


end
