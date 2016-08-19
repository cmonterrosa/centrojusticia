class CustomsController < ApplicationController
  before_filter :login_required
  


  def index
    @usuario=current_user
    if @usuario.has_role?(:admin)
        return render(:partial => 'adminnew', :layout => "oficial")
    elsif @usuario.has_role?(:visitadores)
        return render(:partial => 'visitadores', :layout => "oficial")
    elsif @usuario.has_role?(:direccion)
        return render(:partial => 'direccion', :layout => "oficial")
    elsif @usuario.has_role?(:admindireccion)
        return render(:partial => 'admindireccion', :layout => "oficial")
    elsif @usuario.has_role?(:subdireccion)
        return render(:partial => 'subdireccion', :layout => "oficial")
    elsif @usuario.has_role?(:especialistas)
        return render(:partial => 'especialistas', :layout => "oficial")
    elsif @usuario.has_role?(:especialistas_externos)
        return render(:partial => 'especialistas_externos', :layout => "oficial")
    elsif @usuario.has_role?(:oficinasubdireccion)
        return render(:partial => 'oficinasubdireccion', :layout => "oficial")
    elsif @usuario.has_role?(:jefeatencionpublico)
        return render(:partial => 'jefeatencionpublico', :layout => "oficial")
    elsif @usuario.has_role?(:invitadores)
        return render(:partial => 'invitadores', :layout => "oficial")
     elsif @usuario.has_role?(:convenios)
        return render(:partial => 'convenios', :layout => "oficial")
    elsif @usuario.has_role?(:atencionpublico)
        return render(:partial => 'atencionpublico', :layout => "oficial")
    elsif @usuario.has_role?(:controlagenda)
        return render(:partial => 'controlagenda', :layout => 'oficial')
   elsif @usuario.has_role?(:captura)
        return render(:partial => 'captura', :layout => "oficial")
    elsif @usuario.has_role?(:asignahorario)
        return render(:partial => 'asignahorario', :layout => "oficial")
    elsif @usuario.has_role?(:capacitacion)
        return render(:partial => 'capacitacion', :layout => "oficial")
    else
        return render(:partial => 'publico_general', :layout => "oficial")
    end
  end

  def library
    
  end

  def profile
    @usuario = current_user
  end

  def activity
    @usuario = current_user
    @actividades = Movimiento.find(:all, :select => "m.*", :joins => "m, situacions s", :conditions => ["m.situacion_id=s.id AND s.descripcion NOT IN (?) AND m.user_id = ? AND m.fecha_inicio > ?", ["EN SESION", "GUARDIA", "BAJA"], current_user.id, Time.now], :order => "fecha_inicio DESC")
    @guardia = Situacion.find_by_descripcion("GUARDIA")
    @guardias = Movimiento.find(:all, :conditions => ["user_id = ? AND situacion_id = ? AND fecha_inicio > ?", current_user.id, @guardia.id, Time.now], :order => "fecha_inicio")
    @sesiones = Sesion.find(:all, :conditions => ["(mediador_id = ? OR comediador_id = ?) AND fecha > ? AND (cancel =0 OR CANCEL IS NULL)", current_user.id, current_user.id, Time.now])

    if current_user.has_role?(:subdireccion) || current_user.has_role?(:direccion) || current_user.has_role?(:adminusuarios)
      @especialistas = Role.find_by_name("especialistas").todos_usuarios.sort { |a, b| a.expedientes_sin_concluir.size <=> b.expedientes_sin_concluir.size }
    end
    @especialistas ||= User.find(:all, :conditions => ["id = ?", current_user.id]) if current_user
  end

  def detalle_expedientes
    if current_user.has_role?(:subdireccion) || current_user.has_role?(:direccion) || current_user.has_role?(:adminusuarios) || current_user.has_role?(:especialistas)
      @usuario = (current_user.has_role?(:admin))?  User.find(params[:id]) : nil
      @usuario ||= (current_user.has_role?(:especialistas))? current_user : User.find(params[:id])
      @expedientes = @usuario.expedientes_sin_concluir
      render :partial => "expedientes_sin_concluir", :layout => "only_jquery"
    else
      flash[:notice] = "No tiene privilegios de acceder a esta sección"
      redirect_to :controller => "home"
    end
  end

  def edit
    @user = current_user
  end

  def save
    @user = current_user
    @user.update_attributes(params[:user])
    @user.activated_at ||= Time.now
    @user.activo=true
    success = @user && @user.save
    if success && @user.errors.empty?
      flash[:notice] = "Tus datos se actualizaron correctamente"
      redirect_to :controller => "customs"
    else
      flash[:notice]  = "No se pudieron modificar tus datos, verifica"
      render :action => 'edit'
    end
  end

  def management
    redirect_to :action => "show_calendario"
  end

  def show_calendario
     @sesion = Sesion.new
     @sesiones = (params[:id] == "all") ? Sesion.find(:all, :select=> ["DISTINCT tramite_id,mediador_id,comediador_id,horario_id,fecha,minutos,sala_id, s.*"], :joins => "s, horarios h", :conditions => ["s.horario_id=h.id AND (cancel is NULL OR cancel=0)"], :order => "s.fecha, h.hora,h.minutos") :  Sesion.find(:all, :select => "DISTINCT tramite_id,mediador_id,comediador_id,horario_id,fecha,minutos,sala_id", :conditions => ["(cancel is NULL OR cancel=0) AND fecha is not NULL and (mediador_id = ? OR comediador_id = ?)", current_user.id, current_user.id], :order => "fecha")
     @title = (params[:id] == "all") ? "Calendario general": "Calendario personalizado para #{current_user.nombre_completo}"
     @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
  end


  #----- Manejo de sesiones ---
  def search_sesiones
    if params[:sesion] && params[:sesion][:fecha] =~ /^\d{4}\/\d{1,2}\/\d{1,2}$/
      @fecha = params[:sesion][:fecha] if params[:sesion][:fecha]
      @horarios = Horario.find_by_sql(["select * from horarios where id not in (select horario_id  as id from sesions where fecha = ?)",  DateTime.parse(@fecha)])
      @sesiones = Sesion.find(:all, :conditions => ["fecha is not NULL and (mediador_id = ? OR comediador_id = ?)", current_user.id, current_user.id], :order => "fecha")
      @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
      @title = "Resultados encontrados"
      @horarios_disponibles = Horario.find_by_sql(["select * from horarios where id not in (select horario_id  as id from sesions where fecha = ?) and activo=1 group by hora,minutos order by hora,minutos,sala_id", DateTime.parse(@fecha)])
      @salas = Sala.find(:all, :order => "descripcion")
    else
      redirect_to :action => "show_calendario"
    end
  end


  def mis_expedientes
    @user = (params[:id])? User.find(params[:id]) : current_user
    if @user.has_role?(:especialistas) || @user.has_role?(:especialistas_externos)
        ### Si recibe parametros ###
        @carpeta_atencion = (params[:carpeta_atencion] =~ /^\d{1,4}\/\d{4}$/) ? params[:carpeta_atencion].strip : nil if params[:carpeta_atencion]
        folio_expediente, anio=@carpeta_atencion.split("/") if @carpeta_atencion
        @sesiones_mediador = Sesion.find(:all, :conditions => ["mediador_id = ? ", @user.id], :order => "fecha, hora, minutos, created_at")
        @sesiones_comediador = Sesion.find(:all, :conditions => ["comediador_id = ? AND (cancel IS NULL OR cancel=0)", @user.id], :order => "fecha, hora, minutos, created_at")
        @tramites_concluidos =   Concluido.find(:all, :conditions => ["user_id = ?", @user.id])
        @tramites_ids =  @sesiones_mediador.map{|s|s.tramite_id} + @sesiones_comediador.map{|s|s.tramite_id} + @tramites_concluidos.map{|t|t.tramite_id}


        ## Filtrado de tramites ###
        @tramites = (folio_expediente && anio)?  Tramite.find(:all, :conditions => ["folio_expediente =? AND anio=? AND id in (?)", folio_expediente, anio, @tramites_ids], :order => "anio DESC, folio_expediente DESC") : nil
        @tramites ||= Tramite.find(:all, :conditions => ["id in (?)", @tramites_ids], :order => "anio DESC, folio_expediente DESC") if @tramites_ids
        #@tramites = @tramites.sort{|a,b| a.numero_expediente <=> b.numero_expediente}.reverse
        @tramites = @tramites.paginate(:page => params[:page], :per_page => 15)
        @destino = "mis_expedientes"
        render :partial => "mis_expedientes", :layout => "kolaval"
    else
      flash[:notice]= "El usuario no es especialista"
      redirect_to :controller => "home"
    end

    
  end

end
