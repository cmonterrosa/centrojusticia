#!/bin/env ruby
# encoding: utf-8
class TramitesController < ApplicationController
  layout :set_layout
  before_filter :login_required
  require_role [:cancelatramite, :direccion], :for => [:cancel]
  require_role [:especialistas, :subdireccion, :direccion, :convenios, :asignahorario], :for => [:menu]
  require_role [:admin], :for => [:destroy]


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
  
  def filtrar_tramites
    @carpeta_atencion = (params[:carpeta_atencion] =~ /^\d{1,4}\/\d{4}$/) ? params[:carpeta_atencion].strip : nil
    folio_expediente, anio=@carpeta_atencion.split("/") if @carpeta_atencion
    @participante = (params[:participante].size > 0) ? params[:participante].strip : nil
    @especialista = (params[:especialista]) ? User.find(params[:especialista]) : nil
    @razon_social = (params[:razon_social].size > 0) ? params[:razon_social] : nil

    ### CARPETA DE ATENCION ###
    @tramites = (@carpeta_atencion) ? Tramite.find(:all, :conditions => ["anio = ? and folio_expediente = ?", anio, folio_expediente]) : nil
    
    ### PARTICIPANTE ###
    if @participante
      id_tramites=Array.new
      @participantes_comparecencia ||= Participante.find(:all, :conditions => ["full_name like ?", "#{@participante}%"])
      @solicitante ||= Orientacion.find(:all, :conditions => ["full_name like ?", "#{@participante}%"])
      if @participantes_comparecencia
          @participantes_comparecencia.each do |p|
            @comparecencia = (p.comparecencia)? p.comparecencia.tramite : nil
            (@comparecencia) ? id_tramites << @comparecencia : nil
          end
      end
      @tramites ||= Tramite.find(:all, :conditions => ["id in (?)", id_tramites.map{|i|i.id}]) unless id_tramites.empty?
      id_tramites = []
      if @solicitantes
            @solicitantes.each do |s|
              (s.tramite) ? id_tramites << s.tramite.id : nil
            end
      end
      @tramites ||= Tramite.find(:all, :conditions => ["id in (?)", id_tramites.map{|i|i.id}]) unless id_tramites.empty?
      #@tramites = @tramites.sort{|a,b| a.created_at <=> b.created_at}.reverse unless id_tramites.empty?
    end

    #### RAZON SOCIAL ####

   if @razon_social
      id_tramites=Array.new
      @participantes_comparecencia ||= Participante.find(:all, :conditions => ["razon_social like ?", "#{@razon_social}%"])
      if @participantes_comparecencia
          @participantes_comparecencia.each do |p|
            @comparecencia = (p.comparecencia)? p.comparecencia.tramite : nil
            (@comparecencia) ? id_tramites << @comparecencia : nil
          end
      end
      @tramites ||= Tramite.find(:all, :conditions => ["id in (?)", id_tramites.map{|i|i.id}]) unless id_tramites.empty?
   end

    @tramites ||= Array.new
    @tramites = @tramites.paginate(:page => params[:page], :per_page => 25)
   end


  def list
    @estatus_unicos = Estatu.find_by_sql(["select distinct(estatu_id) as id from estatus_roles where role_id in (?)", current_user.roles])
    #@tramites = (params[:t] == "all") ? Tramite.find(:all, :conditions => ["estatu_id in (?)", @estatus_unicos], :order => "fechahora DESC") : Tramite.find(:all, :conditions => ["estatu_id in (?)", @estatus_unicos], :order => "fechahora DESC LIMIT 35")
    #@all = true if params[:t] == "all"
    #@tramites =  Tramite.find(:all, :conditions => ["estatu_id in (?)", @estatus_unicos], :order => "anio DESC, folio_expediente DESC, fechahora DESC").paginate(:page => params[:page], :per_page => 25)
    @tramites = (current_user.has_role?("atencionpublico"))? Tramite.find(:all, :conditions => ["estatu_id in (?)", @estatus_unicos], :order => "fechahora DESC").paginate(:page => params[:page], :per_page => 25) : Tramite.find(:all, :conditions => ["estatu_id in (?)", @estatus_unicos], :order => "anio DESC, folio_expediente DESC, fechahora DESC").paginate(:page => params[:page], :per_page => 25)
    
  end

  def show
    if params[:id] && params[:id] =~/^\d{1,6}$/
    unless @tramite=Tramite.find(:first, :conditions => ["id = ?", params[:id]])
      flash[:notice] = "No se encontro trámite, verifique"
      redirect_back_or_default('/')
    end
    else
      redirect_back_or_default('/')
    end
  end

  def show_pdf
      if params[:id] && params[:id] =~/^\d{1,6}$/
        unless @tramite=Tramite.find(:first, :conditions => ["id = ?", params[:id]])
          flash[:notice] = "No se encontro trámite, verifique"
          redirect_back_or_default('/')
        end
    else
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


 ######### ACTUALIZACION DE ESTATUS ###############
  def update_estatus
    @tramite = Tramite.find(params[:id])
    #---- excepciones -----
      if params[:new_st]
        case Estatu.find(params[:new_st]).clave
            when "comp-conc" 
                ##--- LEVANTAR COMPARECENCIAS --
                redirect_to :action => "new_or_edit", :controller => "comparecencias", :id => @tramite

            when "mate-asig"
                ##--- ASIGNACION DE MATERIA --
                return render(:partial => 'asignacion_materia', :layout => "oficial")

            when "espe-asig"
                ##--- ASIGNACION DE ESPECIALISTA --
                session["tramite_id"] = @tramite.id
                @fecha_hora_sesion = (Sesion.find_by_tramite_id(@tramite.id)) ? Sesion.find_by_tramite_id(@tramite.id).start_at : nil
                @especialistas = (@fecha_hora_sesion) ? Role.find_by_name("ESPECIALISTAS").usuarios_disponibles_sesiones(@fecha_hora_sesion) :  Role.find_by_name("ESPECIALISTAS").users
                @tipos_sesiones = Tiposesion.find(:all)
                @new_st = params[:new_st]
                if !(@users = @especialistas.sort{|p1,p2| p1.nombre_completo <=> p2.nombre_completo}).empty?
                    return render(:partial => 'asignacion_especialista', :layout => "oficial")
                else
                    return render(:partial => 'no_asignacion_especialista', :layout => "oficial")
                end

            when "fech-asig"
                 ##---- ASIGNACION DE FECHA Y HORA DE SESION ----
                 @sesion = Sesion.find(:first, :conditions => ["tramite_id = ? AND cancel IS NULL", @tramite.id])
                 if @sesion
                    redirect_to :action => "asignar_horario", :controller => "sesiones", :id => @sesion.id, :mediador_id => @sesion.mediador_id, :comediador_id => @sesion.comediador_id
                 else
                    redirect_to :action => "list"
                 end

            when "camb-sesi"  
                 ### --- CAMBIO DE FECHA DE SESIÓN -------
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
                @sesion = Sesion.find(:first, :conditions => ["tramite_id = ?", @tramite.id], :order => "fecha DESC")
                ###-- Buscamos a los participantes para generarles su invitacion ####
                @participantes = Participante.find(:all, :conditions => ["comparecencia_id = ?", @tramite.comparecencia])
                if !@participantes.empty? && current_user.has_role?("subdireccion")
                  @participantes.each do |p|
                    invitacion = Invitacion.find(:first, :conditions => ["participante_id = ? AND sesion_id = ?", p.id, @sesion.id])
                    invitacion ||= Invitacion.new
                    invitacion.sesion ||= @sesion
                    invitacion.participante_id ||= p.id
                    invitacion.user_id ||= current_user.id
                    invitacion.save
                  end
                  @sesion.signed_at = Time.now
                  @sesion.signer_id = current_user.id
                  @sesion.save
                  @e ||= Estatu.find_by_clave("invi-proc")
                  update_tramite_model
                else
                  redirect_to :action => "show", :controller => "invitaciones", :id=> @tramite
                end
                
            when "tram-admi"
                #### -- ADMISION DE TRAMITE ----
                return  render(:partial => 'admitir_tramite', :layout => "oficial")
                update_tramite_model

            when "invi-razo"
                ##---- INVITACIONES RAZONADAS ----
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
                  @e= Estatu.find_by_clave("espe-asig") if current_user.has_role?("subdireccion")
                  @e ||= Estatu.find_by_clave("mate-asig") if current_user.has_role?("convenios")
                  (params[:type] == "admitir" && @e) ?  update_tramite_model("update_estatus", {:id => @tramite.id, :new_st => @e.id,  }) : update_tramite_model
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
              @sesion.activa = true
              if @sesion.save
                 @e= Estatu.find_by_clave("fech-asig") if current_user.has_role?("subdireccion")
                 (params[:type] == "asignar" && @e) ?  update_tramite_model("update_estatus", {:id => @tramite.id, :new_st => @e.id,  }) : update_tramite_model

                #update_tramite_model #if @sesion.save
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
      @tramites = Tramite.find(:all, :conditions => ["estatu_id = ?", @estatu.id], :order => "fechahora DESC").paginate(:page => params[:page], :per_page => 25) if @estatu
    end
     @tramites ||= Tramite.find(:all, :conditions => ["estatu_id in (?)", @estatus_unicos], :order => "fechahora DESC").paginate(:page => params[:page], :per_page => 25)
    return render(:partial => 'listajaxbasic', :layout => false) if request.xhr?
  end

  def filtro_nombre
      if params[:search_nombre]
        if params[:search_nombre].size > 5
            @nombre = params[:search_nombre]
            @tramites ||= Tramite.find(:all, :select => "t.*", :joins => "t, orientacions o", :conditions => ["t.id = o.tramite_id AND o.nombre like ?", "#{@nombre.upcase}%"], :order => "t.fechahora DESC").paginate(:page => params[:page], :per_page => 25)
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
        @tramites ||= Tramite.find(:all, :select => "t.*", :joins => "t, orientacions o", :conditions => ["t.id = o.tramite_id AND o.paterno like ?", "#{@paterno.upcase}%"], :order => "t.fechahora DESC").paginate(:page => params[:page], :per_page => 25)
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
        @tramites = Tramite.find(:all, :conditions => ["anio = ? AND folio_expediente = ?", anio, folio]).paginate(:page => params[:page], :per_page => 25)
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
    @users = (@fecha_hora_sesion) ? Role.find_by_name("ESPECIALISTAS").usuarios_disponibles_sesiones(@fecha_hora_sesion) :  Role.find_by_name("ESPECIALISTAS").users
    #@users.delete(User.find(params[:sesion_mediador_id]))
    @users = @users.sort{|p1,p2| p1.nombre_completo <=> p2.nombre_completo}
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

  def update_tramite_model(action=nil, params={})
    flash[:notice] = (@tramite.update_flujo_estatus!(current_user, @e)) ? "Registro actualizado correctamente" :  "No se pudo guardar, verifique"
    url=(action && !params.empty?)? "/tramites/#{action}?#{params.to_param}" : {:action => "list"}
    redirect_to url
  end

  #### REPORTE PDF #####

  
  def set_layout
    (action_name == 'show_pdf')? 'pdf' : 'kolaval'
  end

end
