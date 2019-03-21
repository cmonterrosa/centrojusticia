#!/bin/env ruby
# encoding: utf-8
include SendDocHelper
class InvitacionesController < ApplicationController
  require_role [:direccion, :subdireccion, :invitadores, :controlinvitaciones, :jefeatencionpublico]

  #before_filter :invitaciones_habilitadas

  def index
    @user = (params[:id])? User.find(params[:id]) : current_user
    if @user.has_role?(:controlinvitaciones)
        ### Si recibe parametros ###
        @carpeta_atencion = (params[:carpeta_atencion] =~ /^\d{1,4}\/\d{4}$/) ? params[:carpeta_atencion].strip : nil if params[:carpeta_atencion]
        folio_expediente, anio=@carpeta_atencion.split("/") if @carpeta_atencion
        ## Filtrado de tramites ###
        @tramites = (folio_expediente && anio)?  Tramite.find(:all, :conditions => ["folio_expediente =? AND anio=?", folio_expediente, anio], :order => "anio DESC, folio_expediente DESC") : nil
        @tramites = @tramites.sort{|a,b| a.numero_expediente <=> b.numero_expediente}.reverse if @tramites
        @tramites = @tramites.paginate(:page => params[:page], :per_page => 25) if @tramites
        @destino = "index"
        render :partial => "busqueda_expediente", :layout => "kolaval"
    else
      flash[:notice]= "El usuario no tiene privilegios suficientes, contacte al administrador"
      redirect_to :controller => "home"
    end
  end

  def save_datos
    @datosinvitacion = Datosinvitacion.find(params[:id]) if params[:id]
    @datosinvitacion ||= Datosinvitacion.new
    @datosinvitacion.update_attributes(params[:datosinvitacion])
    @sesion = Sesion.find(params[:sesion]) if params[:sesion]
    @datosinvitacion.sesion = @sesion if @sesion
    @datosinvitacion.user = current_user if current_user
    if @datosinvitacion.save
      flash[:notice] = "Datos de la Invitacion guardados correctamente"
      redirect_to :action => "list_by_sesion", :datosinvitacion => @datos_invitacion, :id => @sesion
    else
      flash[:error] = "No se puedo guadar, verifique"
      render :action => "list_by_sesion", :id => @sesion
    end
  end


    #--- ajax actions ----
  def show_datos_generales
    @sesion = Sesion.find(params[:id])
    @datosinvitacion = Datosinvitacion.find_by_sesion_id(@sesion) if @sesion
    @datosinvitacion = Datosinvitacion.find(params[:datosinvitacion]) if params[:datosinvitacion]
    @datosinvitacion ||= Datosinvitacion.new
    ##### Prellenado de parametros ######
    @subdireccion = current_user.subdireccion
    @datosinvitacion.subdireccion ||= (@subdireccion.descripcion) ? @subdireccion.descripcion.downcase.titleize : nil if @subdireccion
    @datosinvitacion.subdirector ||= @subdireccion.titular if @subdireccion
    @datosinvitacion.cargo ||= @subdireccion.cargo.downcase.capitalize if @subdireccion
    @datosinvitacion.fechahora_sesion ||= @sesion.fechahora_completa.camelize
    @datosinvitacion.materia ||= (@sesion.tramite && @sesion.tramite.materia)? @sesion.tramite.materia.descripcion : nil if @sesion.tramite
    @datosinvitacion.especialista ||= (@sesion.mediador) ? @sesion.mediador.nombre_completo : nil
    @datosinvitacion.fecha_actual ||= DateTime.now.strftime("%d de %B de %Y").gsub(/^0/, '')
    @datosinvitacion.lugar ||= LUGAR
    @datosinvitacion.fecha_solicitud ||= (@sesion.tramite.orientacion && @sesion.tramite.orientacion.fechahora)? "#{@sesion.tramite.orientacion.fechahora.strftime("%d de")} #{Date::MONTHNAMES[@sesion.tramite.orientacion.fechahora.month].downcase}".gsub(/^0/, '') : nil
    @datosinvitacion.solicitante ||= (@sesion.tramite.comparecencia && @sesion.tramite.comparecencia.solicitante) ? @sesion.tramite.comparecencia.solicitante.full_name : nil
    @datosinvitacion.genero_solicitante ||= (@sesion.tramite.comparecencia && @sesion.tramite.comparecencia.solicitante) ? @sesion.tramite.comparecencia.solicitante.sexo : nil
    @datosinvitacion.genero_solicitante = (@datosinvitacion.genero_solicitante == 'F')? 'LA' : 'EL' if @datosinvitacion.genero_solicitante
    return render(:partial => 'show_datos_invitacion', :layout => 'only_jquery')
  end

  def show_invitados
    @sesion = Sesion.find(params[:id])
    @tramite ||= @sesion.tramite
    @datosinvitacion = Datosinvitacion.find(:first, :conditions => ["sesion_id = ?", @sesion]) if @sesion
    @comparecencia = Comparecencia.find(:first, :conditions => ["tramite_id = ?",  @tramite])
    return render(:partial => 'list_invitados', :layout => 'only_jquery')
  end




  def list_by_sesion
    @sesion = Sesion.find(params[:id])
    @datosinvitacion = Datosinvitacion.find_by_sesion_id(@sesion) if @sesion
    @datosinvitacion = Datosinvitacion.find(params[:datosinvitacion]) if params[:datosinvitacion]
    @datosinvitacion ||= Datosinvitacion.new
    ##### Prellenado de parametros ######
    @subdireccion = current_user.subdireccion
    @datosinvitacion.subdireccion ||= (@subdireccion.descripcion) ? @subdireccion.descripcion : nil if @subdireccion
    @datosinvitacion.subdirector ||= @subdireccion.titular if @subdireccion
    @datosinvitacion.cargo ||= @subdireccion.cargo if @subdireccion
    @datosinvitacion.fechahora_sesion ||= @sesion.fechahora_completa
    @datosinvitacion.materia ||= (@sesion.tramite && @sesion.tramite.materia)? @sesion.tramite.materia.descripcion : nil if @sesion.tramite
    @datosinvitacion.especialista ||= (@sesion.mediador) ? @sesion.mediador.nombre_completo : nil
    @datosinvitacion.fecha_actual ||= DateTime.now.strftime("%d de %B de %Y")
    @datosinvitacion.lugar ||= LUGAR
    @datosinvitacion.fecha_solicitud ||= (@sesion.tramite.orientacion && @sesion.tramite.orientacion.fechahora)? "#{@sesion.tramite.orientacion.fechahora.strftime("%d de").downcase} #{Date::MONTHNAMES[@sesion.tramite.orientacion.fechahora.month].downcase}" : nil
    @datosinvitacion.solicitante ||= (@sesion.tramite.comparecencia && @sesion.tramite.comparecencia.solicitante) ? @sesion.tramite.comparecencia.solicitante.full_name : nil
    @datosinvitacion.genero_solicitante ||= (@sesion.tramite.comparecencia && @sesion.tramite.comparecencia.solicitante) ? @sesion.tramite.comparecencia.solicitante.sexo : nil
    unless @sesion
      redirect_to :controller => "home"
    end
  end


  def firmar
    
  end


  ###### LISTADOS DE INVITACIONES #######


  def show_all
     #@invitaciones = Invitacion.find(:all, :conditions => ["entregada IS NULL and participante_id IS NOT NULL"], :order => ["created_at DESC"])
     @invitaciones = Invitacion.find(:all, :select => "invitacions.*, p.cuadrante_id, t.id as tramite_id, t.anio, t.folio_expediente, t.created_at",
                                    :joins => ["invitacions,participantes p, sesions s, tramites t, estatus e"],
                                    :conditions => ["invitacions.participante_id=p.id AND invitacions.sesion_id=s.id AND s.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in (?) AND invitacions.entregada IS NULL", ["invi-firm", "invi-proc"]],
                                    :order => "t.anio DESC, t.folio_expediente DESC").paginate(:page => params[:page], :per_page => 25)

  end

  def show_entregadas
    @invitaciones = Invitacion.find(:all, :select => "invitacions.*, p.cuadrante_id, t.id as tramite_id, t.anio, t.folio_expediente, t.created_at",
                                    :joins => ["invitacions,participantes p, sesions s, tramites t, estatus e"],
                                    :conditions => ["invitacions.participante_id=p.id AND invitacions.sesion_id=s.id AND s.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in (?) AND invitacions.entregada IS NOT NULL", ["invi-firm", "invi-proc"]],
                                    :order => "t.anio DESC, t.folio_expediente DESC").paginate(:page => params[:page], :per_page => 25)

  end


 ######## ASIGNACION DE INVITADOR #######

  def asignar_invitador
    @invitacion = Invitacion.find(params[:id])
    @participante =  Participante.find(@invitacion.participante_id)
    @tramite = @participante.comparecencia.tramite
    @invitadores = Role.find_by_name("invitadores").todos_usuarios
  end

  def save_asignacion
    @invitacion = Invitacion.find(params[:id])
    @invitacion.update_attributes(params[:invitacion])
    @tramite = Tramite.find(params[:tramite]) if params[:tramite]
    if @invitacion.save
      @tramite.update_estatus!("invi-proc", current_user)
      flash[:notice] = "Invitacion asignada correctamente"
      redirect_to :action => "show_all"
    else
      flash[:error] = "No se pudo asignar, verifique"
      render :action => "asignar_invitador"
    end
  end


  ############# IMPRESION DE PDF ############

  def generar
    @invitacion = Invitacion.find(params[:id])
    if @invitacion
       @sesion = @invitacion.sesion
       @tramite = @sesion.tramite
       @involucrado = Participante.find(params[:p]) if params[:p]
       @involucrado ||= Participante.find(:first,
                      :conditions => ["perfil = 'INVOLUCRADO' AND comparecencia_id = ?", Comparecencia.find_by_tramite_id(@tramite).id])
       @tramite = @invitacion.sesion.tramite
       return false unless @involucrado

       # Timestamp for printing for a invitador
       if current_user.has_role?("invitadores")
         #update_tramite_model(@invitacion.sesion.tramite) if @invitacion.printed_at.nil? && !@invitacion.sesion.tramite.estatus.clave == "invi-razo"
         @tramite.update_estatus!("invi-proc",current_user) if @invitacion.printed_at.nil?
         @invitacion.update_attributes!(:printed_at => Time.now) if @invitacion.printed_at.nil?
       end

       ## Timestamp for director role ##
       # si el director manda a imprimir desde listado de invitaciones
        if current_user.has_role?("direccion") || current_user.has_role?("subdireccion")
          if params[:token]
            @invitacion.update_attributes!(:printed_at => Time.now)  if params[:token] == "h9jqwo8h7s"
          end
        end

       #-- Parametros
       @configuracion = Configuracion.find(1)
       param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
       param["P_APP_URL"]={:tipo=>"String", :valor=>RAILS_ROOT}
       param["P_NOMBRE"]={:tipo=>"String", :valor=>@involucrado.nombre_completo}
       #param["P_ESPECIALISTA"]={:tipo=>"String", :valor=>"Lic. Amauri Palacios Aquino"}
       param["P_ESPECIALISTA"]={:tipo=>"String", :valor=>@invitacion.especialista.nombre_completo}
       #param["P_SUBDIRECTOR"]={:tipo=>"String", :valor=>"Rodrigo Domínguez Moscoso"}

       #### Nuevos parametros #####
       param["P_SUBDIRECCION_NOMBRE"] = (SUBDIRECCION)? {:tipo=>"String", :valor=>SUBDIRECCION} : {:tipo=>"String", :valor=>"SUBDIRECCIÓN REGIONAL CENTRO"}
       param["P_NUMERO_EXPEDIENTE"]=(@invitacion.orientacion.tramite)? {:tipo=>"String", :valor=>@invitacion.orientacion.tramite.numero_expediente} : {:tipo=>"String", :valor=>"---"}
       param["P_DIRECCION_OFICINAS"]=(@configuracion)? {:tipo=>"String", :valor=>@configuracion.pie_pagina} : {:tipo=>"String", :valor=>"calle Candoquis número 290, esquina con avenida Pino, fraccionamiento El Bosque, en la ciudad de Tuxtla Gutiérrez, Chiapas"}
       param["P_MATERIA"]=(@invitacion.orientacion.tramite.materia)? {:tipo=>"String", :valor=>@invitacion.orientacion.tramite.materia.descripcion} : {:tipo=>"String", :valor=>"FAMILIAR"}
       
       ### Numero de invitacion ###
       case @invitacion.numero_invitacion
       when 2
         @leyenda_invitacion="SEGUNDA INVITACIÓN"  
       when 3
         @leyenda_invitacion="TERCERA INVITACIÓN"
       when 4
         @leyenda_invitacion="CUARTA INVITACIÓN"
       else
         @leyenda_invitacion=nil
       end
      
      param["P_NUMERO_INVITACION"]= {:tipo=>"String", :valor=>@leyenda_invitacion}

       if current_user.has_role?("direccion")
          d = Subdireccion.find_by_cargo("Director General")
          param["P_FIRMANTE"]={:tipo=>"String", :valor=>d.titular}
          param["P_CARGO"]={:tipo=>"String", :valor=>d.cargo}
       else
          param["P_FIRMANTE"]={:tipo=>"String", :valor=>@invitacion.subdireccion.titular}
          param["P_CARGO"]={:tipo=>"String", :valor=>@invitacion.subdireccion.cargo}
       end
       param["P_ARTICULO"]={:tipo=>"String", :valor=>@invitacion.articulo}
       #param["P_LUGAR"]={:tipo=>"String", :valor=>"Tuxtla Gutiérrez, Chiapas;"}
       param["P_LUGAR"]={:tipo=>"String", :valor=>"#{@invitacion.subdireccion.municipio.descripcion}, CHIAPAS;"}
       #param["P_FECHA"]={:tipo=>"String", :valor=>"21 de Diciembre de 2012"}
       param["P_FECHA"]={:tipo=>"String", :valor=>"#{Time.now.strftime('%d de %B de %Y')}"}
       param["P_FECHA_ORIENTACION"]={:tipo=>"String", :valor=>"#{@invitacion.orientacion.created_at.strftime('%d de %B de %Y')}"}
       #param["P_SOLICITANTE"]={:tipo=>"String", :valor=>"C. Norma Espinoza Vázquez"}
       param["P_SOLICITANTE"]={:tipo=>"String", :valor=>@invitacion.orientacion.solicitante}
       param["P_FECHA_ORIENTACION"]={:tipo=>"String", :valor=>"#{@invitacion.orientacion.created_at.strftime('%d de %B de %Y')}"}
       #param["P_FECHA_SESION"]={:tipo=>"String", :valor=>"05 de marzo, a las 3 de la tarde"}
       param["P_FECHA_SESION"]={:tipo=>"String", :valor=>"#{@invitacion.fecha_sesion}"}
       param["P_ARTICULO_ESP"] = {:tipo => "String", :valor => @invitacion.articulo_esp}
        if File.exists?(REPORTS_DIR + "/invitacion2014.jasper")
           send_doc_jdbc("invitacion2014", "invitacion2014", param, output_type = 'pdf')
       else
          render :text => "Error"
       end
    else
      render :text => "Imposible generar invitación, verifique los parámetros"
    end

#----- parametros anteriores --
#    param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
#    param["P_FOLIO"]={:tipo=>"String", :valor=>params[:ciclo]}
#    param["P_LUGAR"]={:tipo=>"String", :valor=>REPORTS_DIR}
#    #param["P_PARTICIPANTE"]={:tipo=>"String", :valor=>@participante.nombre_completo}
#
#    param["P_MUNICIPIO"]={:tipo=>"integer", :valor=>params[:municipio_id]}
#    if File.exists?(REPORTS_DIR + "/#{params[:reporte]}.jasper")
#        send_doc_jdbc(params[:reporte], params[:reporte],  param, output_type = 'pdf')
#    else
#      flash[:notice] = "Error al invocar el reporte, seleccione una opción válida"
#      redirect_to :action => "listados_index2"
#    end

  end

  
  def imprimir
    @participante = Participante.find(params[:participante])
    @perfil = @participante.perfil
    @sesion = Sesion.find(params[:id])
    @datosinvitacion = Datosinvitacion.find(:first, :conditions => ["sesion_id = ?", @sesion]) if @sesion
    @invitacion = Invitacion.find(:first, :conditions => ["participante_id = ?", @participante ]) if @participante
    @invitacion ||= Invitacion.new
    @invitacion.datosinvitacion = @datosinvitacion if @datosinvitacion
    @invitacion.participante ||= @participante if @participante
    @invitacion.sesion ||= @sesion if @sesion
    @invitacion.user = current_user if current_user
    @invitacion.numero_invitacion ||= @sesion.num_invitacion if @sesion.num_invitacion
    @tramite = @sesion.tramite
    @configuracion = Configuracion.find(:all).first
    @configuracion.pie_pagina
    
    if @sesion && @datosinvitacion
       if current_user.has_role?("invitadores")
         @tramite.update_estatus!("invi-proc",current_user) if @invitacion.printed_at.nil?
         @invitacion.update_attributes!(:printed_at => Time.now) if @invitacion.printed_at.nil?
       end

        ############## PARAMETROS ###################
       param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
       param["APP_URL"]={:tipo=>"String", :valor=>RAILS_ROOT}
       param["P_EXPEDIENTE"]={:tipo=>"String", :valor=>(@sesion.tramite) ? @sesion.tramite.numero_expediente : nil}
       #param["P_FECHA_ACTUAL"]={:tipo=>"String", :valor=>(@datosinvitacion.fecha_actual) ? @datosinvitacion.fecha_actual.strftime("%d DE %B DE %Y").upcase : nil}
       param["P_FECHA_ACTUAL"]={:tipo=>"String", :valor=> (@datosinvitacion.fecha_actual)? "#{@datosinvitacion.fecha_actual.strftime("%d de ")} #{Date::MONTHNAMES[@datosinvitacion.fecha_actual.month].downcase} de #{@datosinvitacion.fecha_actual.year}".gsub(/^0/,'') : nil}
       param["P_ESPECIALISTA"]={:tipo=>"String", :valor=>@datosinvitacion.especialista}
       param["P_SUBDIRECCION"]={:tipo=>"String", :valor=>@datosinvitacion.subdireccion}
       param["P_SOLICITANTE"]={:tipo=>"String", :valor=>@datosinvitacion.solicitante.mb_chars.downcase.titleize}
       param["P_INVITADO"]={:tipo=>"String", :valor=> @participante.tipopersona_id==1? "C. #{@participante.nombre_completo.mb_chars.downcase.titleize}" : @participante.nombre_completo.mb_chars.downcase.titleize}
       param["P_FECHA_SOLICITUD"]={:tipo=>"String", :valor=>@datosinvitacion.fecha_solicitud.downcase}
       param["P_FECHAHORA_SESION"]={:tipo=>"String", :valor=>@datosinvitacion.fechahora_sesion.downcase}
       param["P_MATERIA"]={:tipo=>"String", :valor=>@datosinvitacion.materia.downcase}
       param["P_LUGAR"]={:tipo=>"String", :valor=>(@datosinvitacion.lugar)? "#{@datosinvitacion.lugar.mb_chars.downcase.titleize}, Chiapas" : nil }
       param["P_GENERO"]={:tipo=>"String", :valor=>@datosinvitacion.genero_solicitante}
       param["P_DIRECCION_OFICINAS"]=(@configuracion.pie_pagina)? {:tipo=>"String", :valor=>@configuracion.pie_pagina} : {:tipo=>"String", :valor=>"Solicite al administrador actualice el domicilio de las oficinas"}
       param["P_ESPECIALISTA_SEXO"]={:tipo=>"String", :valor=>@sesion.mediador.articulo_segun_genero} if @datosinvitacion.especialista && @sesion.mediador

      ### Numero de invitacion ###
      if @invitacion && @invitacion.numero_invitacion
          case @invitacion.numero_invitacion
            when 2
              @leyenda_invitacion="Segundo citatorio"
              param["P_NUMERO_INVITACION"]= {:tipo=>"String", :valor=>@leyenda_invitacion}
            when 3
              @leyenda_invitacion="TERCERA INVITACIÓN"
            when 4
              @leyenda_invitacion="CUARTA INVITACIÓN"
          else
          @leyenda_invitacion=nil
          end
      end

      ###  Leyenda del parrafo de asignacion segun sexo y segun si es uno o dos mediadores   ###
      if @sesion.mediador_id == @sesion.comediador_id 
        if @sesion.mediador.sexo == "F"
          if current_user.has_role?("especialistajuzgado")
            param["P_DESIGNACION"]={:tipo=>"String", :valor=> "ha sido designada para atender el asunto la especialista público quien suscribe el presente ocurso."}
          else
            param["P_DESIGNACION"]={:tipo=>"String", :valor=> "ha sido designada para atender el asunto la especialista públlico <b>#{@datosinvitacion.especialista.mb_chars.downcase.titleize}</b>."}          
          end  
        else
          if current_user.has_role?("especialistajuzgado")
            param["P_DESIGNACION"]={:tipo=>"String", :valor=> "ha sido designado para atender el asunto el especialista público quien suscribe el presente ocurso."}
          else           
            param["P_DESIGNACION"]={:tipo=>"String", :valor=> "ha sido designado para atender el asunto el especialista público <b>#{@datosinvitacion.especialista.mb_chars.downcase.titleize}</b>."}          
          end
        end
      else
        if @sesion.mediador.sexo == "F" && @sesion.comediador.sexo == "M"           
          param["P_DESIGNACION"]={:tipo=>"String", :valor=> "han sido designados para atender el asunto los especialistas públicos <b>#{@datosinvitacion.especialista.mb_chars.downcase.titleize} y #{@sesion.comediador.nombre_completo.mb_chars.downcase.titleize}</b>, la primera en su caracter de titular."}
        elsif @sesion.mediador.sexo == "F" && @sesion.comediador.sexo == "F"           
          param["P_DESIGNACION"] = {:tipo=>"String", :valor=> "han sido designadas para atender el asunto las especialistas públicos <b>#{@datosinvitacion.especialista.mb_chars.downcase.titleize} y #{@sesion.comediador.nombre_completo.mb_chars.downcase.titleize}</b>, la primera en su caracter de titular."}
        else          
          param["P_DESIGNACION"] = {:tipo=>"String", :valor=> "han sido designados para atender el asunto los especialistas públicos <b>#{@datosinvitacion.especialista.mb_chars.downcase.titleize} y #{@sesion.comediador.nombre_completo.mb_chars.downcase.titleize}</b>, el primero en su caracter de titular."}
        end
      end

      #param["P_NUMERO_INVITACION"]= {:tipo=>"String", :valor=>@leyenda_invitacion}
       if current_user.has_role?("direccion")
          d = Subdireccion.find_by_cargo("DIRECTOR GENERAL")
          param["P_SUBDIRECTOR"]={:tipo=>"String", :valor=>d.titular.mb_chars.downcase.titleize}
          param["P_CARGO"]={:tipo=>"String", :valor=>d.cargo.mb_chars.downcase.titleize}
       elsif current_user.has_role?("especialistajuzgado")
          param["P_SUBDIRECTOR"]={:tipo=>"String", :valor=>current_user.nombre_completo.mb_chars.downcase.titleize}
          param["P_CARGO"]={:tipo=>"String", :valor=>current_user.categoria.mb_chars.downcase.titleize}
       else
          param["P_SUBDIRECTOR"]={:tipo=>"String", :valor=>@datosinvitacion.subdirector.mb_chars.downcase.titleize}
          param["P_CARGO"]={:tipo=>"String", :valor=>@datosinvitacion.cargo.mb_chars.downcase.titleize}
       end
       @comparecencia = @invitacion.sesion.tramite.comparecencia if @invitacion.sesion.tramite
       if @invitacion.save
            if @perfil == 'SOLICITANTE'
                param["P_INVOLUCRADOS_DESCRIPCION"]={:tipo=>"String", :valor=>@comparecencia.descripcion_involucrados_con_articulo} if @comparecencia && @comparecencia.descripcion_involucrados_con_articulo
                (File.exists?(REPORTS_DIR + "/nueva_invitacion.jasper"))?  send_doc_jdbc("nueva_invitacion", "nueva_invitacion", param, output_type = 'pdf') : (render :text => "<h3>Error de invitación del solicitante, contacte al administrador del sistema</h3>")
            else
                param["P_SOLICITANTES_DESCRIPCION"]={:tipo=>"String", :valor=>@comparecencia.descripcion_solicitantes_con_articulo} if @comparecencia && @comparecencia.descripcion_solicitantes_con_articulo
                (File.exists?(REPORTS_DIR + "/nueva_invitacion_involucrado.jasper"))?  send_doc_jdbc("nueva_invitacion_involucrado", "nueva_invitacion", param, output_type = 'pdf') : (render :text => "<h3>Error de invitación del involucrado, contacte al administrador del sistema</h3>")
            end
        end
    else
      render :text => "Imposible generar invitación, verifique los parámetros"
    end
  end


  def list_by_tramite
    @tramite = Tramite.find(params[:id])
    @sesiones = Sesion.find(:all, :conditions => ["tramite_id = ?", @tramite.id])
    @invitaciones= (@sesiones.empty?)? nil :  Invitacion.find(:all, :conditions => ["sesion_id in (?)", @sesiones.collect{|s| s.id}]).paginate(:page => params[:page], :per_page => 15)
  end

  def list_by_user
    @cuadrantes = current_user.cuadrantes
    @invitaciones_cuadrantes = Invitacion.find(:all, :select => "invitacions.*, cu.descripcion as cuadrante, t.id as tramite_id, s.fecha as fecha_sesion",
                                    :joins => ["invitacions,participantes p, cuadrantes cu, sesions s, tramites t, estatus e"],
                                    :conditions => ["invitacions.participante_id=p.id AND p.cuadrante_id=cu.id AND invitacions.sesion_id=s.id AND s.tramite_id=t.id AND t.estatu_id=e.id AND e.clave in (?) AND cu.id in (?)", ["invi-firm", "invi-proc"], @cuadrantes.map{|x|x.id}],
                                    :order => "cu.descripcion")
    @invitaciones_asignadas =  Invitacion.find(:all, :select => "invitacions.*, p.cuadrante_id as cuadrante, t.id as tramite_id, t.anio, t.folio_expediente, t.created_at, s.fecha as fecha_sesion",
                                    :joins => ["invitacions,participantes p, sesions s, tramites t, estatus e"],
                                    :conditions => ["invitador_id = ? AND invitacions.participante_id=p.id AND invitacions.sesion_id=s.id AND s.tramite_id=t.id AND t.estatu_id=e.id AND e.clave = ?", current_user.id, "invi-proc"],
                                    :order => "t.anio DESC, t.folio_expediente DESC")
    @invitaciones = @invitaciones_cuadrantes + @invitaciones_asignadas
    @invitaciones.sort{|p1, p2| p1.fecha_sesion <=> p2.fecha_sesion}
    @invitaciones = @invitaciones.paginate(:page => params[:page], :per_page => 15)
  end

  def razonar
    @invitacion = Invitacion.find(params[:id])
    @invitadores = Role.find_by_name("invitadores").todos_usuarios.sort { |a, b| a.nombre_completo <=> b.nombre_completo  }
    unless @invitacion
      flash[:error] =  "La invitación no existe"
      redirect_to :action => "index"
    end
  end

  def destroy
    if params[:id] && @invitacion = Invitacion.find(params[:id])
      (@invitacion.destroy) ? flash[:notice] = "Registro eliminado correctamente" : flash[:error] = "No se pudo eliminar, verique"
        redirect_to :action => "show_all"
      end
   end
  


  def save
    if params[:id] && @invitacion = Invitacion.find(params[:id])
      unless @invitacion.entregada == true && @invitacion.fecha_hora_entrega.nil?
        @change_status = true
      end
      @invitacion.entregada ||= params[:invitacion][:entregada]
      @invitacion.justificacion ||= params[:invitacion][:justificacion]
      anio, mes, dia, hora, minutos = params[:invitacion]["fecha_hora_entrega(1i)"],  params[:invitacion]["fecha_hora_entrega(2i)"],  params[:invitacion]["fecha_hora_entrega(3i)"], params[:invitacion]["fecha_hora_entrega(4i)"], params[:invitacion]["fecha_hora_entrega(5i)"]
      date = DateTime.civil(anio.to_i,mes.to_i,dia.to_i,hora.to_i, minutos.to_i)
      @invitacion.fecha_hora_entrega ||= date if date
      @invitacion.invitador_id ||= params[:invitacion][:invitador_id] if params[:invitacion][:invitador_id]
      if @invitacion.save
        # Actualizamos status
        # Si se cambia la hora por primera vez
        update_tramite_model(@invitacion.sesion.tramite) if @change_status
        flash[:notice] = "Invitacion actualizada correctamente"
      else
        flash[:error] = "No se pudo guardar verifique"
        render :action => "razonar"
      end
    else
       flash[:notice] ||= "No existe invitacion"
    end
    redirect_to :action => "list_by_user"
  end


  def menu_print
    #@invitacion = Invitacion.find(params[:id])
    #@participantes = @invitacion.sesion.tramite.comparecencia.participantes
    
       @cuadrantes = current_user.cuadrantes
       @participantes = Participante.find(:all, :select => "t.id as tramite_id, t.anio, t.folio_expediente, s.signed_at, invitacions.id as invitacion_id, participantes.*, cu.descripcion as cuadrante",
                                    :joins => ["participantes, invitacions invitacions, sesions s, tramites t, comparecencias c, cuadrantes cu"],
                                    :conditions => ["invitacions.sesion_id=s.id AND s.tramite_id=t.id AND c.tramite_id=t.id AND 
                                                     c.id=participantes.comparecencia_id AND participantes.cuadrante_id=cu.id AND participantes.cuadrante_id IN (?)", @cuadrantes.map{|x|x.id}],
                                    :order => "s.fecha, s.hora, s.minutos")
  end

  def show
    if params[:id] && @invitacion = Invitacion.find(params[:id])
      @tramite = @invitacion.sesion.tramite
    else
      flash[:notice] = "No se encontro invitacion"
      redirect_to :action => "list_by_user"
    end
  end

  def show_entregadas_by_user
    @cuadrantes = current_user.cuadrantes
#    @invitaciones_cuadrantes = Invitacion.find(:all, :select => "invitacions.*, cu.descripcion as cuadrante, t.id as tramite_id",
#                                    :joins => ["invitacions,participantes p, cuadrantes cu, sesions s, tramites t, estatus e"],
#                                    :conditions => ["invitacions.participante_id=p.id AND p.cuadrante_id=cu.id AND invitacions.sesion_id=s.id AND s.tramite_id=t.id AND t.estatu_id=e.id AND e.clave = ? AND invitacions.invitador_id = ?", "invi-razo", current_user.id],
#                                    :order => "cu.descripcion")

    @invitaciones_asignadas = Invitacion.find(:all, :select => "invitacions.*, p.cuadrante_id as cuadrante, t.id as tramite_id, t.anio, t.folio_expediente, t.created_at",
                                    :joins => ["invitacions,participantes p, sesions s, tramites t, estatus e"],
                                    :conditions => ["invitador_id = ? AND invitacions.participante_id=p.id AND invitacions.sesion_id=s.id AND s.tramite_id=t.id AND t.estatu_id=e.id AND e.clave = ?", current_user.id, "invi-razo"],
                                    :order => "t.anio DESC, t.folio_expediente DESC")                     
    @invitaciones =  @invitaciones_asignadas
    #@invitaciones = Invitacion.find(:all, :conditions => ["entregada = ? AND invitador_id = ?", true, current_user.id], :order => "fecha_hora_entrega DESC")
  end


  def notificar_entrega_personal
    @invitacion = Invitacion.find(params[:id])
    @invitacion.entregada = true
    @invitacion.fecha_hora_entrega = Time.now
    @invitacion.invitador_id = current_user.id
    if @invitacion.save
       @tramite = @invitacion.sesion.tramite
       @tramite.update_estatus!("invi-pers",current_user) if @tramite
       flash[:notice] = "Se actualizo registro correctamente"
       redirect_to :action => "list_by_tramite", :id=> @tramite
    end
  end

 protected

  def invitaciones_habilitadas
    unless (INVITACIONES)
        flash[:info] = "El módulo de invitaciones no se encuentra autorizado, verifique con el administrador"
        redirect_to :controller => "home"
    end
  end


end
