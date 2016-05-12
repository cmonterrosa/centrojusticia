#!/bin/env ruby
# encoding: utf-8
include SendDocHelper
class ComparecenciasController < ApplicationController
  layout 'kolaval'
  require_role [:subdireccion, :especialistas, :especialistas_externos, :convenios, :oficinasubdireccion, :direccion, :captura_inicios_externos, :admindireccion]
  

  def show
    @comparecencia = Comparecencia.find(:first, :conditions => ["tramite_id = ?", params[:id]]) if params[:id]
    @tramite = (@comparecencia) ? @comparecencia.tramite : Tramite.find(params[:id]) if params[:id]
    @comparecencia ||= Comparecencia.new
    @comparecencia.tramite ||= Tramite.find(params[:id])
  end

  def new_or_edit
    redirect_to :action => "show", :id => params[:id]
  end

  def generar_pdf_reserva_sesion
    @sesion = Sesion.find(params[:id])
    @tramite = @sesion.tramite
    @comparecencia = Comparecencia.find_by_tramite_id(@tramite.id) if @tramite
    if @sesion && @tramite && @comparecencia
       param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
       param["APP_URL"]={:tipo=>"String", :valor=>RAILS_ROOT}
       param["P_PRESIDENTE"]={:tipo=>"String", :valor=>MAGISTRADO_PRESIDENTE}
       param["P_SUBDIRECCION"]={:tipo=>"String", :valor=>SUBDIRECCION}
       param["P_FECHA_CAPTURA"]={:tipo=>"String", :valor=>@sesion.created_at}
       param["P_SOLICITANTE"]=(@comparecencia.solicitante) ? {:tipo=>"String", :valor=>@comparecencia.solicitante.nombre_completo} : {:tipo=>"String", :valor=>""}
       param["P_ESPECIALISTA"]=(@comparecencia.user_id) ? {:tipo=>"String", :valor=>User.find(@comparecencia.user_id).nombre_completo} : {:tipo=>"String", :valor=>""}
       param["P_FECHA_HORA_CAPTURA"]= (@sesion.created_at) ? {:tipo=>"String", :valor=>@sesion.created_at.strftime("%d DE %B DE %Y / %H:%M").upcase} :  {:tipo=>"String", :valor=>"---"}
       param["P_NUM_EXPEDIENTE"]=(@tramite.numero_expediente) ? {:tipo=>"String", :valor=>@tramite.numero_expediente} : {:tipo=>"String", :valor=>""}
       param["P_FOLIO"]={:tipo=>"String", :valor=>@tramite.folio_integrado}
       param["P_SOLICITANTES"]=(@comparecencia.solicitantes) ? {:tipo=>"String", :valor=>@comparecencia.solicitantes} : {:tipo=>"String", :valor=>""}
       param["P_INVOLUCRADOS"]=(@comparecencia.involucrados) ? {:tipo=>"String", :valor=>@comparecencia.involucrados} : {:tipo=>"String", :valor=>""}
       if File.exists?(REPORTS_DIR + "/reserva_sesion.jasper")
           send_doc_jdbc("reserva_sesion", "reserva_sesion", param, output_type = 'pdf')
       else
          render :text => "Error"
       end
    else
      flash[:notice] = "Imposible generar ticket de reserva, verifique parámetros"
      redirect_to :action => "show", :id => params[:id]
    end
 end

  ####################################################
  # Generacion de documentos para impresion en formato PDF
  #
  #
  ####################################################


  def generar_pdf_observaciones
         @solicitante = Participante.find(params[:participante])
      if @solicitante && @solicitante.perfil == "SOLICITANTE" && @solicitante.observaciones.size > 4
         @comparecencia = Comparecencia.find(params[:id])
         param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
         param["APP_URL"]={:tipo=>"String", :valor=>RAILS_ROOT}
         param["P_EXPEDIENTE"]=(@comparecencia.tramite)? {:tipo=>"String", :valor=>@comparecencia.tramite.numero_expediente} :  {:tipo=>"String", :valor=>"--"}
         param["P_SUBDIRECCION"]={:tipo=>"String", :valor=>SUBDIRECCION}
         param["P_SOLICITANTE"]={:tipo=>"String", :valor=>@solicitante.nombre_completo}
         param["P_FECHA"]={:tipo=>"String", :valor=>"#{@comparecencia.fechahora.strftime('%d DE %B DE %Y').upcase}"}
         param["P_OBSERVACIONES"]={:tipo=>"String", :valor=>clean_string(@solicitante.observaciones)}
         param["P_ESPECIALISTA"]={:tipo=>"String", :valor=>User.find(@comparecencia.user_id).nombre_completo}
         if File.exists?(REPORTS_DIR + "/impresion_observaciones_solicitante.jasper")
           send_doc_jdbc("impresion_observaciones_solicitante", "impresion_observaciones_solicitante", param, output_type = 'pdf')
           #send_doc_jdbc("comparecencia", "comparecencia", param, output_type = 'pdf')
         else
           render :text => "Error"
        end
    else
        render :text => "Imposible generar reporte involucrado, verifique los parámetros"
    end
 end

    def generar_pdf_involucrado
    @involucrado = Participante.find(params[:participante])
    @comparecencia = Comparecencia.find(params[:id])
    if (@involucrado && @involucrado.perfil == "INVOLUCRADO" && @comparecencia)
       param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
       param["APP_URL"]={:tipo=>"String", :valor=>RAILS_ROOT}
       param["P_SUBDIRECCION"]={:tipo=>"String", :valor=>SUBDIRECCION}
       param["P_NOMBRE_INVOLUCRADO"]={:tipo=>"String", :valor=>@involucrado.nombre_completo}
       if @involucrado.edad
        (@involucrado.edad > 0) ? param["P_EDAD"]={:tipo=>"String", :valor=>"#{@involucrado.edad} AÑOS"} : param["P_EDAD"]={:tipo=>"String", :valor=>""}
       end
       param["P_SEXO"]={:tipo=>"String", :valor=>@involucrado.sexo_descripcion}
       param["P_ORIGINARIO"]={:tipo=>"String", :valor=>@involucrado.originario}
       param["P_TELEFONO_CASA"]={:tipo=>"String", :valor=>@involucrado.telefono_particular}
       param["P_TELEFONO_TRABAJO"]={:tipo=>"String", :valor=>@involucrado.telefono_celular_aux}
       param["P_TELEFONO_CELULAR"]={:tipo=>"String", :valor=>@involucrado.telefono_celular}
       param["P_CORREO_ELECTRONICO"]={:tipo=>"String", :valor=>@involucrado.correo}
       param["P_OBSERVACIONES"]={:tipo=>"String", :valor=>clean_string(@involucrado.observaciones)}
       param["P_DOMICILIO"]={:tipo=>"String", :valor=>clean_string(@involucrado.domicilio_ubicacion)}
       param["P_DOMICILIO_LABORAL"]={:tipo=>"String", :valor=>clean_string(@involucrado.domicilio_laboral)}
       #param["P_TIPO_DOMICILIO"]={:tipo=>"String", :valor=>clean_string(@involucrado.tipo_domicilio_ubicacion)}
       param["P_REFERENCIA_DOMICILIARIA"]={:tipo=>"String", :valor=>clean_string(@involucrado.domicilio_referencias_ubicacion)}
       param["P_REFERENCIA_DOMICILIARIA_LABORAL"]={:tipo=>"String", :valor=>clean_string(@involucrado.referencias_domiciliares_laboral)}
       param["P_ESTADO_CIVIL"]=(@involucrado.estado_civil) ? {:tipo=>"String", :valor=>clean_string(@involucrado.estado_civil.descripcion)} :  {:tipo=>"String", :valor=>"---"}
       param["P_ETNIA"]=(@involucrado.pertenece_grupo_etnico && @involucrado.etnia) ? {:tipo=>"String", :valor=>clean_string(@involucrado.etnia.descripcion)} :  {:tipo=>"String", :valor=>""}
       param["P_ESPECIALISTA"]={:tipo=>"String", :valor=>User.find(@comparecencia.user_id).nombre_completo}

        if @comparecencia.solicitante
          solicitante ={:tipo=>"String", :valor=>clean_string(@comparecencia.solicitante.nombre_completo)} if @comparecencia.solicitante.nombre && @comparecencia.solicitante.nombre.size > 0
          solicitante ||= {:tipo=>"String", :valor=>clean_string(@comparecencia.solicitante.apoderado_legal)} if @comparecencia.solicitante.apoderado_legal && @comparecencia.solicitante.apoderado_legal.size > 0
          solicitante ||= {:tipo=>"String", :valor=>clean_string(@comparecencia.solicitante.razon_social)} if @comparecencia.solicitante.razon_social && @comparecencia.solicitante.razon_social.size > 0
        end
        param["P_SOLICITANTE"] = solicitante if solicitante

        #---- Validación de tipo de persona ------
       (@involucrado.tipopersona) ?  param["P_TIPO_PERSONA"]={:tipo=>"String", :valor=>@involucrado.tipopersona.descripcion} :  param["P_TIPO_PERSONA"]={:tipo=>"String", :valor=> "" }
       (@involucrado.tipopersona.descripcion == "MORAL" && @involucrado.razon_social) ?  param["P_RAZON_SOCIAL"]={:tipo=>"String", :valor=>@involucrado.razon_social.upcase} :  param["P_RAZON_SOCIAL"]={:tipo=>"String", :valor=> " "}
        
        ##### SOLO PARA PERSONAS MORALES ######
        param["P_FECHA"]={:tipo=>"String", :valor=>"#{fecha_string(@comparecencia.fechahora)}"}
        param["P_APODERADO_LEGAL"]={:tipo=>"String", :valor=>clean_string(@involucrado.apoderado_legal)}
        (@comparecencia.tramite.numero_expediente) ? param["P_EXPEDIENTE"]={:tipo=>"String", :valor=>@comparecencia.tramite.numero_expediente} : nil
        if File.exists?(REPORTS_DIR + "/involucrado.jasper")
          (@involucrado.tipopersona.descripcion == "MORAL") ? send_doc_jdbc("involucrado_persona_moral", "involucrado_persona_moral", param, output_type = 'pdf') : send_doc_jdbc("involucrado", "involucrado", param, output_type = 'pdf')
          #send_doc_jdbc("involucrado", "involucrado", param, output_type = 'pdf')
        else
          render :text => "Error"
        end

    else
      flash[:error] = "Imposible generar reporte del involucrado, verifique parámetros"
      redirect_to :action => "show", :id => params[:id]
    end
 end


  def generar_pdf_acta_comparecencia
      @solicitante = Participante.find(params[:participante])
      if @solicitante && @solicitante.perfil == "SOLICITANTE"
        @comparecencia = Comparecencia.find(params[:id])
        param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
        param["APP_URL"]={:tipo=>"String", :valor=>RAILS_ROOT}
        param["P_SUBDIRECCION"]={:tipo=>"String", :valor=>SUBDIRECCION}
        param["P_FECHA"]={:tipo=>"String", :valor=>"#{fecha_string(@comparecencia.fechahora)}"}
        @comparecencia.procedencia ? param["P_PROCEDENCIA"]={:tipo=>"String", :valor=>@comparecencia.procedencia.upcase} : param["P_PROCEDENCIA"]={:tipo=>"String", :valor=>"SIN INFORMACION"}
        (@solicitante.tipopersona.descripcion == "MORAL") ?  param["P_SOLICITANTE"]={:tipo=>"String", :valor=>@solicitante.apoderado_legal} :  param["P_SOLICITANTE"]={:tipo=>"String", :valor=>@solicitante.nombre_completo}
        if @solicitante.edad
          (@solicitante.edad > 0) ? param["P_EDAD"]={:tipo=>"String", :valor=>"#{@solicitante.edad} AÑOS"} : param["P_EDAD"]={:tipo=>"String", :valor=>""}
        end
        param["P_SEXO"]={:tipo=>"String", :valor=>@solicitante.sexo_descripcion}
        param["P_ORIGINARIO"]={:tipo=>"String", :valor=>@solicitante.originario}
        @comparecencia.caracter ? param["P_CARACTER"]={:tipo=>"String", :valor=>clean_string(@comparecencia.caracter).upcase} : param["P_CARACTER"]={:tipo=>"String", :valor=>"SIN INFORMACION"}
        param["P_DOMICILIO"]={:tipo=>"String", :valor=>clean_string(@solicitante.domicilio)}
        param["P_DOMICILIO_LABORAL"]={:tipo=>"String", :valor=>clean_string(@solicitante.domicilio_laboral)}
        #param["P_TIPO_DOMICILIO"]={:tipo=>"String", :valor=>clean_string(@solicitante.tipo_domicilio_ubicacion)}
        param["P_REFERENCIA_DOMICILIARIA"]={:tipo=>"String", :valor=>clean_string(@solicitante.referencia_domiciliaria)}
        param["P_REFERENCIA_DOMICILIARIA_LABORAL"]={:tipo=>"String", :valor=>clean_string(@solicitante.referencias_domiciliares_laboral)}
        param["P_ESTADO_CIVIL"]=(@solicitante.estado_civil) ? {:tipo=>"String", :valor=>clean_string(@solicitante.estado_civil.descripcion)} :  {:tipo=>"String", :valor=>"---"}
        param["P_ETNIA"]=(@solicitante.pertenece_grupo_etnico && @solicitante.etnia) ? {:tipo=>"String", :valor=>clean_string(@solicitante.etnia.descripcion)} :  {:tipo=>"String", :valor=>""}
        param["P_TELEFONO_CASA"]={:tipo=>"String", :valor=>@solicitante.telefono_particular}
        param["P_TELEFONO_TRABAJO"]={:tipo=>"String", :valor=>@solicitante.telefono_celular_aux}
        param["P_TELEFONO_CELULAR"]={:tipo=>"String", :valor=>@solicitante.telefono_celular}
        param["P_CORREO"]={:tipo=>"String", :valor=>@solicitante.correo}
        param["P_HORARIO_PREFERENCIA"]= (@comparecencia.disponibilidad_horario && @comparecencia.disponibilidad_horario == 'SI') ? {:tipo=>"String", :valor=> "DISPONIBILIDAD DE HORARIO"} : {:tipo=>"String", :valor=>@comparecencia.dia_preferencia.upcase + " (#{@comparecencia.hora_preferencia} HRS.)"}
        conocimiento = (@comparecencia.conocimiento) ? "SÍ" : "NO"
        param["P_CONOCIMIENTO"]={:tipo=>"String", :valor=>conocimiento}
        param["P_DATOS"]={:tipo=>"String", :valor=>clean_string(@comparecencia.datos)}
        param["P_ASUNTO"]={:tipo=>"String", :valor=>(@comparecencia.asunto).gsub(/\$/, '\$')}
        param["P_ASUNTO"]={:tipo=>"String", :valor=>clean_string(@comparecencia.asunto)}
        param["P_ESPECIALISTA"]={:tipo=>"String", :valor=>User.find(@comparecencia.user_id).nombre_completo}
        param["P_TIPO_PERSONA"]={:tipo=>"String", :valor=>@solicitante.tipopersona.descripcion}
        
        
        ####### Parametros para personas morales ########
        param["P_APODERADO_LEGAL"]={:tipo=>"String", :valor=>clean_string(@solicitante.apoderado_legal)}
        param["P_RAZON_SOCIAL"]={:tipo=>"String", :valor=>clean_string(@solicitante.razon_social)}
        (@comparecencia.tramite.numero_expediente) ? param["P_EXPEDIENTE"]={:tipo=>"String", :valor=>@comparecencia.tramite.numero_expediente} : nil
        if File.exists?(REPORTS_DIR + "/comparecencia.jasper")
          (@solicitante.tipopersona.descripcion == "MORAL") ? send_doc_jdbc("comparecencia_persona_moral", "comparecencia_persona_moral", param, output_type = 'pdf') : send_doc_jdbc("comparecencia", "comparecencia", param, output_type = 'pdf')
          #send_doc_jdbc("comparecencia", "comparecencia", param, output_type = 'pdf')
        else
          render :text => "Error"
        end
    else
        render :text => "Imposible generar reporte involucrado, verifique los parámetros"
    end
   end


  def save
    @tramite = Tramite.find(params[:tramite])
    if @tramite.comparecencia
       @comparecencia= @tramite.comparecencia
       @comparecencia.datos = (params[:comparecencia][:datos] && params[:comparecencia][:datos].size > 0) ? params[:comparecencia][:datos] : nil
       @comparecencia.update_attributes(params[:comparecencia])
    else
      @tramite.update_estatus!("comp-conc", current_user) # update estatus of tramite
      #NotificationsMailer.deliver_tramite_created(@tramite, @tramite.user) # sends the email
      @comparecencia = Comparecencia.new(params[:comparecencia])
      @comparecencia.tramite = @tramite
    end
    @comparecencia.conocimiento = (params[:comparecencia] && params[:comparecencia][:conocimiento] == 'SI') ? true : false
     ###########################################################
     # Verificamos si el registro se inicio como extraordinaria para establecerle el usuario seleccionado
     ###########################################################
     if current_user.has_role?(:captura_inicios_externos)
        if @extraordinaria = Extraordinaria.find(:first, :conditions => ["tramite_id = ?", @comparecencia.tramite.id])
          @comparecencia.user = @extraordinaria.especialista  if @extraordinaria.especialista
        end
      end
      @comparecencia.user = current_user unless @comparecencia.user
      
      if @comparecencia.save
       write_log("Comparecencia guardada correctamente: #{@comparecencia.inspect}", current_user)
       unless current_user.has_role?(:especialistas_externos)
         @tramite.generar_folio_expediente!
          flash[:notice] = "Guardado correctamente, Número de Expediente: #{@tramite.numero_expediente}"
       else
          flash[:notice] = "Comparecencia guardada, en espera de generar número de expediente"
       end
      redirect_to :action => "show", :id => @tramite
    else
        flash[:error] = "No se pudo guardar, verifique"
        # render :action => "new_or_edit"
       render :action => "show_informacion_general"
    end
  end


  def list_by_user
    @user = current_user
    @comparecencias = Comparecencia.find(:all, :conditions => ["user_id = ?", current_user], :order => "updated_at DESC").paginate(:page => params[:page], :per_page => 25)

#    @comparecencias = Comparecencia.find(:all,
#                                       :select => ["c.*"],
#                                       :joins => ["c, tramites t"],
#                                       :conditions => ["c.tramite_id = t.id AND c.user_id = ? AND t.estatu_id = ?", @user.id, @estatus.id],
#                                       :order => "c.fechahora")
#
  end



  #--- ajax actions --
  def show_informacion_general
    @comparecencia = Comparecencia.find(:first, :conditions => ["tramite_id = ?", params[:id]]) if params[:id]
    @comparecencia ||= Comparecencia.new
    @comparecencia.tramite ||= Tramite.find(params[:id])
    return render(:partial => 'new_or_edit', :layout => false)
    #render :text => "<h3>Informacion general</h3>"
  end

  def show_participantes
    @comparecencia = Comparecencia.find(:first, :conditions => ["tramite_id = ?", params[:id]]) if params[:id]
    @comparecencia ||= Comparecencia.new
    @comparecencia.tramite ||= Tramite.find(params[:id])
    return render(:partial => 'list_participantes', :layout => false)
  end

  ########## MANEJO DE HORARIO DE SESIONES ######################

  def show_schedules
    unless @sesion = Sesion.find_by_tramite_id(params[:id])
      @tramite = Tramite.find(params[:id]) if params[:id]
      @sesion = Sesion.new
      @sesiones = Sesion.find(:all, :select=> ["s.*"], :joins => "s, horarios h", :conditions => ["s.horario_id=h.id"], :order => "s.fecha, h.hora,h.minutos")
      @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
      @title = "Selección de horario"
      return render(:partial => 'calendario', :layout => "only_jquery")
    else
      redirect_to :action => "generar_pdf_reserva_sesion", :id => @sesion
      #return render(:partial => 'sesion_asignada', :layout => "only_jquery")
    end
  end

  def daily_show
    @tramite = Tramite.find(params[:id]) if params[:id]
    @origin=params[:origin] if params[:origin]
    if params[:year] =~ /^\d{4}$/ && params[:month] =~ /^\d{1,2}$/ && params[:day] =~ /^\d{1,2}$/
       @fecha = DateTime.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
       @before = @fecha.yesterday
       @after = @fecha.tomorrow
       @salas = Sala.find(:all, :order => "descripcion")
       @horarios = Horario.find(:all, :group => "hora,minutos")
       return render(:partial => 'daily_show', :layout => "only_jquery")
    else
      redirect_to :action => @accion
    end
  end


   def add_schedule_to_comparecencia
        @tramite = Tramite.find(params[:id]) if params[:id]
        @fecha = Date.parse(params[:date])
        @horarios = Horario.find_by_sql(["select * from horarios where id not in (select horario_id  as id from sesions where fecha = ?) and activo=1 group by hora,minutos order by hora,minutos,sala_id", @fecha])
        @horario = Horario.find(params[:horario]) if params[:horario]
        @tipos_sesiones = Tiposesion.find(:all, :order => "descripcion")
        @tramite = (params[:id]) ? Tramite.find(params[:id]) : Tramite.new
        @sesiones_activas = (@tramite) ?  Sesion.find(:all, :conditions => ["tramite_id = ? AND concluida = 0", @tramite.id]) : Array.new
        @fecha = Date.parse(params[:date])
        @horarios = Horario.find_by_sql(["select * from horarios where id not in (select horario_id  as id from sesions where fecha = ?) and activo=1 group by hora,minutos order by hora,minutos,sala_id", @fecha])
        @horario = Horario.find(params[:horario]) if params[:horario]
        @tipos_sesiones = Tiposesion.find(:all, :order => "descripcion")
        @tramite = Tramite.find(params[:id]) if params[:id]
        @default_type_of_sesion = Tiposesion.find_by_descripcion("RESERVA DE SESION")
        @especialistas = User.find_by_sql(["SELECT u.* FROM users u
        inner join roles_users ru on u.id=ru.user_id
        inner join roles r on ru.role_id=r.id
        where r.name='ESPECIALISTAS' and
        u.id not in (select mediador_id from sesions WHERE activa = 1 AND fecha = ? AND hora= ? AND minutos= ?) AND
        u.id not in (select comediador_id from sesions WHERE activa = 1 AND fecha = ? AND hora= ? AND minutos= ?) ORDER BY u.nombre, u.paterno, u.materno", @fecha, @horario.hora, @horario.minutos, @fecha, @horario.hora, @horario.minutos ])
        return render(:partial => 'new_sesion_with_date', :layout => "only_jquery")
   end

     def save_with_date
    @tramite = Tramite.find(params[:id]) if params[:id]
    @origin = params[:origin]
    @sesion = Sesion.new(params[:sesion])
    @sesion.tramite = @tramite if @tramite
    @horario = Horario.find(params[:horario]) if params[:horario]
    @sesion.horario = @horario if @horario
    @sesion.horario ||= Horario.find(params[:sesion][:horario_id])
    #---- if tramite has a valid format -----
    @sesion.fecha = Date.parse(params[:date]) if params[:date]
    @sesion.user = current_user
    #--- guardamos historia de hora y minutos ---
    @sesion.hora = @sesion.horario.hora
    @sesion.minutos = @sesion.horario.minutos
    @sesion.sala_id = @sesion.horario.sala_id
    @sesion.activa = true
    @sesion.generate_clave if @sesion.clave.nil?
    @sesion.tiposesion =  Tiposesion.find_by_descripcion("RESERVA DE SESION")
    if @sesion.tramite &&  @sesion.save
       flash[:notice] = "Sesión guardada correctamente, clave: #{@sesion.clave}"
       #redirect_to :action => "daily_show", :day => @sesion.fecha.day, :month=> @sesion.fecha.month, :year => @sesion.fecha.year, :origin => @origin
       redirect_to :action => "generar_pdf_reserva_sesion", :id => @sesion
   else
       flash[:error] = "no se puedo guardar, verifique"
       @fecha = Date.parse(params[:date])
       @tipos_sesiones = Tiposesion.find(:all, :order => "descripcion")
       @especialistas = User.find_by_sql(["SELECT u.* FROM users u
        inner join roles_users ru on u.id=ru.user_id
        inner join roles r on ru.role_id=r.id
        where r.name='ESPECIALISTAS' and
        u.id not in (select mediador_id from sesions WHERE activa = 1 AND fecha = ? AND hora= ? AND minutos= ?) AND
        u.id not in (select comediador_id from sesions WHERE activa = 1 AND fecha = ? AND hora= ? AND minutos= ?) ORDER BY u.nombre, u.paterno, u.materno", @fecha, @horario.hora, @horario.minutos, @fecha, @horario.hora, @horario.minutos ])
       render :action => "add_schedule_to_comparecencia"
    end

  end

     def change_to_orientacion
       @comparecencia = Comparecencia.find(params[:id])
       @tramite = @comparecencia.tramite
       #@margen =  (120 * 60.0) # 120 Minutos
       @margen = ((60 * 60) * 24) * 7
       @partial = params[:token] && params[:token] == "partial"
       if Time.now < (@comparecencia.created_at + @margen) || (Time.now < (@comparecencia.updated_at + @margen))
          @participantes = @comparecencia.participantes
          # start destroy #
          @participantes.each do |p| p.destroy end
          @comparecencia.destroy
          @tramite.undo_status
          @tramite.update_estatus!("no-compar",current_user)
          @tramite.update_attributes!(:folio_expediente => nil)
          flash[:notice] = "Registro actualizado correctamente"
          msj = "<h3 class='formee-msg-success'>#{flash[:notice]}</h3>"
      else
          flash[:error] = "No se pudo cambiar a solo orientacion, tiene hasta 7 días después de concluir, contacte al administrador"
          msj = "<h3 class='formee-msg-error'>#{flash[:error]}</h3>"
      end
      (@partial)? (render :text => msj ) : (redirect_to :action => "list_by_user")
     end

end
