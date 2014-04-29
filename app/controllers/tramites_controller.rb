class TramitesController < ApplicationController
  layout 'oficial_fancy'
  before_filter :login_required
  require_role [:cancelatramite, :direccion], :for => [:cancel]
  require_role [:especialistas, :subdireccion, :direccion, :convenios], :for => [:menu]
  require_role [:admin, :captura], :for => [:destroy]


  def index
  end

  def show_numero_expediente
    if @tramite = Tramite.find(params[:id])
       @orientacion = Orientacion.find_by_tramite_id(@tramite.id)
    end
  end

  ### CANCELACION ###

  def cancel_form
     @tramite = Tramite.find(params[:id])
     return render(:partial => 'cancel', :layout => "only_jquery")
  end

  def cancel
    if @tramite = Tramite.find(params[:id])
       @tramite.update_attributes!(params[:tramite])
       (@tramite.cancel(current_user))? flash[:notice] = "Trámite cancelado" : flash[:notice] = "No se pudo cancelar el trámite"
       return render(:partial => 'success_cancel', :layout => "only_jquery")
    else
       return render(:partial => 'failed_cancel', :layout => "only_jquery")
    end
  end

  def save_numero_expediente
    if params[:id] && params[:tramite][:folio_expediente] =~ /^\d{1,}$/
      @tramite = Tramite.find(params[:id])
      @tramite.update_attributes!(:folio_expediente => params[:tramite][:folio_expediente])
      flash[:notice] = "Número de expediente actualizado correctamente"
      redirect_to :action => "list", :controller => "tramites"
    else
      flash[:notice] = "El formato no es válido, verifique"
      render :action => "show_numero_expediente"
    end
  end

  def list
    @estatus_unicos = Estatu.find_by_sql(["select distinct(estatu_id) as id from estatus_roles where role_id in (?)", current_user.roles])
    @tramites = (params[:t] == "all") ? Tramite.find(:all, :conditions => ["estatu_id in (?)", @estatus_unicos], :order => "fechahora DESC") : Tramite.find(:all, :conditions => ["estatu_id in (?)", @estatus_unicos], :order => "fechahora DESC LIMIT 35")
    @all = true if params[:t] == "all"
  end

  def show
    unless @tramite=Tramite.find(params[:id])
      flash[:notice] = "No se encontro trámite, verifique"
      redirect_back_or_default('/')
    end
  end

  def pdf
    @tramite = Tramite.find(params[:id])
    make_and_send_pdf("resumen_#{@tramite.anio.to_s}_#{@tramite.folio.to_s}")
  end

  def destroy
    @tramite = Tramite.find(params[:id])
    @orientacion = Orientacion.find_by_tramite_id(params[:id])
    @historico = Historia.find_by_tramite_id(params[:id])
    if ((@orientacion) ? @orientacion.destroy : true) && ((@historico) ? @historico.destroy : true) && ((@tramite) ? @tramite.destroy : false)
      flash[:notice] = "Registro eliminado correctamente"
    else
      flash[:notice] = "No se pudo eliminar, verifique"
    end
    redirect_to :action => "list"
  end

  def showpdf
    #@tramite = Tramite.find(1)
    respond_to do |format|
       format.html
       format.pdf do
        render :pdf => "file_name",
               :template => "tramites/showpdf.erb",
               :stylesheets => ["application","prince"],
               :layout => "pdf",
               :disposition => "inline" # PDF will be sent inline, means you can load it inside an iFrame or Embed
      end
    end
  end

  def menu
    unless @tramite=Tramite.find(params[:id])
      flash[:notice] = "No se encontro trámite, verifique"
      redirect_back_or_default('/')
    end
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

 #---- actualización de estatus ----
  def update_estatus
    @tramite = Tramite.find(params[:id])
    #---- excepciones -----
      if params[:new_st]
        case Estatu.find(params[:new_st]).clave
            when "comp-conc" 
              ##--- levantar comparecencia --
              redirect_to :action => "new_or_edit", :controller => "comparecencias", :id => @tramite
            when "mate-asig" 
              ##--- asignacion de materia --
              return render(:partial => 'asignacion_materia', :layout => "oficial")
            when "espe-asig" 
               ##--- asignacion de especialista --
               session["tramite_id"] = @tramite.id
               @fecha_hora_sesion = (Sesion.find_by_tramite_id(@tramite.id)) ? Sesion.find_by_tramite_id(@tramite.id).start_at : nil
               @tipos_sesiones = Tiposesion.find(:all)
               #if !(@users = @tramite.materia.users).empty?
                if !(@users = Role.find_by_name("ESPECIALISTAS").usuarios_disponibles_sesiones(@fecha_hora_sesion)).empty?
                    return render(:partial => 'asignacion_especialista', :layout => "oficial")
                else
                    return render(:partial => 'no_asignacion_especialista', :layout => "oficial")
                end
            when "fech-asig" #---- asignación de fecha y hora de sesión ----
                 @sesion = Sesion.find(:first, :conditions => ["tramite_id = ? AND cancel IS NULL", @tramite.id])
                 if @sesion
                    redirect_to :action => "asignar_horario", :controller => "sesiones", :id => @sesion.id, :mediador_id => @sesion.mediador_id, :comediador_id => @sesion.comediador_id
                 else
                    redirect_to :action => "list"
                 end

            when "camb-sesi"  ######## Cambio de fecha de sesion #####
                 @sesion = Sesion.find(:first, :conditions => ["tramite_id = ? AND cancel IS NULL", @tramite.id])
                 (@sesion) ? ( redirect_to :action => "asignar_horario", :controller => "sesiones", :id => @sesion.id, :mediador_id => @sesion.mediador_id, :comediador_id => @sesion.comediador_id, :title => "reasignacion") : (redirect_to :action => "list")
                 
             when "invi-firm"
               @sesion = Sesion.find(:first, :conditions => ["tramite_id = ?", @tramite.id], :order => "fecha DESC")
               @invitacion = Invitacion.find_by_sesion_id(@sesion.id) if @sesion
               @participante = (@tramite.comparecencia.participantes) ? @tramite.comparecencia.participantes.first : nil
               @invitacion ||= Invitacion.create(:user_id => current_user.id, :sesion_id => @sesion.id, :participante_id => @participante.id ) if @participante && @sesion
               @role = Role.find_by_name("invitadores")
               return  render(:partial => 'firma_invitaciones', :layout => "oficial")
            when "invi-proc"
                redirect_to :action => "show", :controller => "invitaciones", :id=> @tramite
            #### Admision de tramite ####
            when "tram-admi"
              return  render(:partial => 'admitir_tramite', :layout => "oficial")
            ### Invitaciones razonadas ###
            when "invi-razo"
              redirect_to :controller => "invitaciones", :action => "list_by_user"
            else
              update_tramite_model
         end
      else

      if params.has_key?(:tramite)
         @primera_asignacion_materia = (@tramite.materia_id) ? true : false
         @tramite.update_attributes(params[:tramite])
         @tramite.procedente=true if params[:tramite]["procedente"] == "1"
         unless @tramite.procedente
              @tramite.update_estatus!("tram-noad",current_user)
              flash[:notice] = "Registro actualizado correctamente"
              redirect_to :action => "list"
         else
               if @tramite.save #&& @primera_asignacion_materia
                update_tramite_model
               else
                redirect_to :action => "list"
               end
         end
         
      elsif params.has_key?(:sesion)
         @sesion = Sesion.find(:first, :conditions => ["tramite_id = ?", params[:id]])
         (@sesion) ? @sesion.update_attributes(params[:sesion]) : @sesion = Sesion.new(params[:sesion])
         @tramite = Tramite.find(params[:id])
         @sesion.tramite_id = @tramite.id if @tramite
         @sesion.num_tramite = @tramite.folio_inverso
         @sesion.generate_clave unless @sesion.clave
         if @sesion && @sesion.comediador_id && @sesion.mediador_id
            if @sesion.save
               update_tramite_model #if @sesion.save
               #NotificationsMailer.deliver_sesion_created("mediador", @sesion)
               #NotificationsMailer.deliver_sesion_created("comediador", @sesion)
               flash[:notice] = "Especialista y comediador notificados asignados"
             else
              flash[:notice] = "No se pudo guardar el registro, verifique"
              redirect_to :action => "list"
            end
         else
            flash[:notice] = "Información incompleta, verifique"
            redirect_to :action => "list"
         end
      
      #--- firma de invitaciones --

      elsif params.has_key?(:infosesion)
        @tramite = Tramite.find(params[:id])
        @invitacion = Invitacion.find(params[:invitacion]) if params[:invitacion]
        @sesion = @invitacion.sesion
        #@invitacion.invitador_id = User.find(params[:infosesion_invitador]).id if params[:infosesion_invitador]
        ############# obtenemos a las personas que se les va a generar invitacion ##########
        ids=[]
        params.keys.each do |x|
          ids << x if x=~ /^\d{1,4}$/
        end
        Participante.find(ids).each do |p|
          invitacion = Invitacion.find_by_participante_id(p.id)
          invitacion ||= Invitacion.new(:user_id => current_user.id, :sesion_id => @sesion.id, :participante_id => p.id )
          invitacion.save
        end
        @invitacion.sesion.signed_at = Time.now
        @invitacion.sesion.signer_id = current_user.id
        @invitacion.save && @invitacion.sesion.save
        flash[:notice] = ( @tramite.update_estatus!("invi-firm", current_user)) ? "Registro actualizado correctamente" :  "No se pudo guardar, verifique"
        redirect_to :action => "list"
      else
        flash[:notice] = "No se pudo cambiar el estatus, verifique"
         redirect_to :action => "list"
      end
   end
 end

  def search
    #--- default parameters --
    @controlador, @id, @accion = "home", nil, "index"
    #-- inicia búsqueda --
    if params[:q]
      case params[:q]
        when /^\d{1,4}$/
          @tramite = Tramite.find(:first, :conditions => ["id = ? or folio = ?", params[:q], params[:q]])
           @controlador, @id, @accion = "tramites", @tramite, "show" if @tramite
        when /^\d{1,4}\/\d{4}$/
          folio,anio = params[:q].split("/")
          @tramite = Tramite.find(:first, :conditions => ["folio = ? and anio = ?", folio, anio])
            @controlador, @id, @accion = "tramites", @tramite, "show" if @tramite
        when /^[a-zA-Z|\s]+$/
          nombre, paterno, materno = params[:q].split(" ")
          nombre.upcase! if nombre
          paterno.upcase! if paterno
          materno.upcase! if materno
          solicitante = Orientacion.find(:first, :conditions => ["nombre = ? AND paterno = ? and materno = ?", nombre, paterno, materno])
          participante = Participante.find(:first, :conditions => ["nombre = ? AND paterno = ? and materno = ?", nombre, paterno, materno])
          @tramite = solicitante.tramite if solicitante
          @tramite ||= participante.comparecencia.tramite if (participante && participante.comparecencia)
           @controlador, @id, @accion = "tramites", @tramite, "show" if @tramite
        when /^\d{1}[a-zA-Z]{2}\d{2,3}$/ #sesion
          @sesion = Sesion.find_by_clave(params[:q].strip)
          @controlador, @id, @accion = "sesiones", @sesion, "show" if @sesion
        else
           flash[:notice] = "No se pudo realizar la búsqueda, verifique"
           #redirect_back_or_default('/')
       end
        redirect_to :action => @accion, :controller => @controlador, :id => @id
    end
  end

   #----- filtros ajax --------
  def filtro_estatus
    if params[:estatu_id].size > 0
      @estatu = Estatu.find(params[:estatu_id])
      @tramites = Tramite.find(:all, :conditions => ["estatu_id = ?", @estatu.id], :order => "fechahora DESC") if @estatu
    end
     @estatus_unicos = Estatu.find_by_sql(["select distinct(estatu_id) as id from estatus_roles where role_id in (?)", current_user.roles])
     @tramites ||= Tramite.find(:all, :conditions => ["estatu_id in (?)", @estatus_unicos], :order => "fechahora DESC")
    return render(:partial => 'listajaxbasic', :layout => false) if request.xhr?
  end

  def filtro_nombre
      if params[:search_nombre]
        if params[:search_nombre].size > 5
            @nombre = params[:search_nombre]
            @tramites ||= Tramite.find(:all, :select => "t.*", :joins => "t, orientacions o", :conditions => ["t.id = o.tramite_id AND o.nombre like ?", "#{@nombre.upcase}%"], :order => "t.fechahora DESC")
            @estatus_unicos = Estatu.find_by_sql(["select distinct(estatu_id) as id from estatus_roles where role_id in (?)", current_user.roles])
            return render(:partial => 'listajaxbasic', :layout => false) if request.xhr?
        end
      end
      render :text => ""
  end



   def filtro_paterno
    if params[:search_paterno]
      if params[:search_paterno].size > 5
        @paterno = params[:search_paterno]
        @tramites ||= Tramite.find(:all, :select => "t.*", :joins => "t, orientacions o", :conditions => ["t.id = o.tramite_id AND o.paterno like ?", "#{@paterno.upcase}%"], :order => "t.fechahora DESC")
        @estatus_unicos = Estatu.find_by_sql(["select distinct(estatu_id) as id from estatus_roles where role_id in (?)", current_user.roles])
        #@tramites ||= Tramite.find(:all, :conditions => ["estatu_id in (?)", @estatus_unicos], :order => "created_at DESC")
        return render(:partial => 'listajaxbasic', :layout => false) if request.xhr?
      end
      render :text => ""
    end
   end

    def filtro_numero_expediente
    if params[:search_numero_expediente]
      if params[:search_numero_expediente].size > 5 && params[:search_numero_expediente] =~ /^\d{1,4}\/\d{4}$/
        folio, anio = params[:search_numero_expediente].split("/")
        @tramites = Tramite.find(:all, :conditions => ["anio = ? AND folio_expediente = ?", anio, folio])
        #@tramites ||= Tramite.find(:all, :select => "t.*", :joins => "t, orientacions o", :conditions => ["t.id = o.tramite_id AND o.paterno like ?", "#{@paterno.upcase}%"], :order => "t.fechahora DESC")
        @estatus_unicos = Estatu.find_by_sql(["select distinct(estatu_id) as id from estatus_roles where role_id in (?)", current_user.roles])
        #@tramites ||= Tramite.find(:all, :conditions => ["estatu_id in (?)", @estatus_unicos], :order => "created_at DESC")
        return render(:partial => 'listajaxbasic', :layout => false) if request.xhr?
      end
      render :text => ""
    end
   end


  def get_comediador
    @tramite =  Tramite.find(session["tramite_id"])
    @fecha_hora_sesion = (Sesion.find_by_tramite_id(@tramite.id)) ? Sesion.find_by_tramite_id(@tramite.id).start_at : nil
    @users = Role.find_by_name("ESPECIALISTAS").usuarios_disponibles_sesiones(@fecha_hora_sesion)
    @users.delete(User.find(params[:sesion_mediador_id]))
    return render(:partial => 'comediadores', :layout => false) if request.xhr?
  end

  def only_orientacion
    @tramite = Tramite.find(params[:id])
    @estatus = Estatu.find_by_clave("no-compar")
    @tramite.estatu_id = @estatus.id if @tramite
    @tramite.only_orientacion = true if @tramite
    @historia = Historia.new(:tramite_id => @tramite.id, :user_id => current_user.id, :estatu_id => @estatus.id) if @tramite && current_user
    if @tramite.save && @historia.save
       #--- Actualizamos estatus --
       flash[:notice] = "Registro actualizado correctamente"
       redirect_to :action => "list_by_user", :controller => "orientacions"
    else
       flash[:notice] = "Registro actualizado correctamente"
       redirect_to :action => "list_by_user", :controller => "orientacions"
    end
  end

  def change_materia
    @tramite = Tramite.find(params[:id])
    return render(:partial => 'asignacion_materia', :layout => "oficial")
  end

protected
  def generar_folio(anio)
    maximo=  Tramite.maximum(:folio, :conditions => ["anio = ?", anio])
    folio = 1 unless maximo
    folio ||= maximo+1
  end

  def update_tramite_model
    flash[:notice] = (@tramite.update_flujo_estatus!(current_user)) ? "Registro actualizado correctamente" :  "No se pudo guardar, verifique"
    redirect_to :action => "list"
  end

end
