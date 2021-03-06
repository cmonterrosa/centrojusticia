include SendDocHelper
class InvitacionesController < ApplicationController
  require_role [:direccion, :subdireccion, :invitadores]

  def index
  end


  def firmar
    
  end


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

       #-- Parametros
       param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
       param["P_APP_URL"]={:tipo=>"String", :valor=>RAILS_ROOT}
       param["P_NOMBRE"]={:tipo=>"String", :valor=>@involucrado.nombre_completo}
       #param["P_ESPECIALISTA"]={:tipo=>"String", :valor=>"Lic. Amauri Palacios Aquino"}
       param["P_ESPECIALISTA"]={:tipo=>"String", :valor=>@invitacion.especialista.nombre_completo}
       #param["P_SUBDIRECTOR"]={:tipo=>"String", :valor=>"Rodrigo Domínguez Moscoso"}
       
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
       #param["P_SOLICITANTE"]={:tipo=>"String", :valor=>"C. Norma Espinoza Vázquez"}
       param["P_SOLICITANTE"]={:tipo=>"String", :valor=>@invitacion.orientacion.solicitante}
       #param["P_FECHA_ORIENTACION"]={:tipo=>"String", :valor=>"17 de febrero de 2012"}
       param["P_FECHA_ORIENTACION"]={:tipo=>"String", :valor=>"#{@invitacion.orientacion.created_at.strftime('%d de %B de %Y')}"}
       #param["P_FECHA_SESION"]={:tipo=>"String", :valor=>"05 de marzo, a las 3 de la tarde"}
       param["P_FECHA_SESION"]={:tipo=>"String", :valor=>"#{@invitacion.fecha_sesion}"}
       param["P_ARTICULO_ESP"] = {:tipo => "String", :valor => @invitacion.articulo_esp}
        if File.exists?(REPORTS_DIR + "/invitacion.jasper")
           send_doc_jdbc("invitacion", "invitacion", param, output_type = 'pdf')
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

  def list_by_tramite
    @tramite = Tramite.find(params[:id])
    @sesiones = Sesion.find(:all, :conditions => ["tramite_id = ?", @tramite.id])
    @invitaciones= (@sesiones.empty?)? nil :  Invitacion.find(:all, :conditions => ["sesion_id in (?)", @sesiones.collect{|s| s.id}])
  end

  def list_by_user
    @cuadrantes = current_user.cuadrantes
    @invitaciones = Invitacion.find(:all, :select => "invitacions.*, cu.descripcion as cuadrante, t.id as tramite_id",
                                    :joins => ["invitacions,participantes p, cuadrantes cu, sesions s, tramites t, estatus e"],
                                    :conditions => ["invitacions.participante_id=p.id AND p.cuadrante_id=cu.id AND invitacions.sesion_id=s.id AND s.tramite_id=t.id AND t.estatu_id=e.id AND e.clave = ? AND cu.id in (?)", "invi-firm", @cuadrantes.map{|x|x.id}],
                                    :order => "cu.descripcion")
  end

  def razonar
    @invitacion = Invitacion.find(params[:id])
    @invitadores = Role.find_by_name("invitadores").users

    #if @invitacion && (@invitacion.invitador_id == current_user.id || current_user.has_role?(Role.find_by_name("admin")))
        
    #else
     # render :text => "No tiene privilegios de razonar la invitación o no existe"
    #end

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
      if @invitacion.save
        # Actualizamos status
        # Si se cambia la hora por primera vez
        update_tramite_model(@invitacion.sesion.tramite) if @change_status
        flash[:notice] = "Invitacion actualizada correctamente"
      else
        flash[:notice] = "No se pudo guardar verifique"
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
    @invitaciones = Invitacion.find(:all, :select => "invitacions.*, cu.descripcion as cuadrante, t.id as tramite_id",
                                    :joins => ["invitacions,participantes p, cuadrantes cu, sesions s, tramites t, estatus e"],
                                    :conditions => ["invitacions.participante_id=p.id AND p.cuadrante_id=cu.id AND invitacions.sesion_id=s.id AND s.tramite_id=t.id AND t.estatu_id=e.id AND e.clave = ? AND invitacions.invitador_id = ?", "invi-razo", current_user.id],
                                    :order => "cu.descripcion")
    
  end

end
