include SendDocHelper
class InvitacionesController < ApplicationController
  def index
  end


  def firmar
    
  end


  def generar
    @invitacion = Invitacion.find(params[:id])
    if @invitacion
       @sesion = @invitacion.sesion
       @tramite = @sesion.tramite
       @involucrado = Participante.find(:first, 
                      :conditions => ["comparecencia_id = ?", Comparecencia.find_by_tramite_id(@tramite).id])
       #-- Parametros
       param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
       #param["P_NOMBRE"]={:tipo=>"String", :valor=>"Carlos Augusto Monterrosa López"}
       param["P_NOMBRE"]={:tipo=>"String", :valor=>@involucrado.nombre_completo}
       #param["P_ESPECIALISTA"]={:tipo=>"String", :valor=>"Lic. Amauri Palacios Aquino"}
       param["P_ESPECIALISTA"]={:tipo=>"String", :valor=>@invitacion.especialista}
       #param["P_SUBDIRECTOR"]={:tipo=>"String", :valor=>"Rodrigo Domínguez Moscoso"}
       param["P_SUBDIRECTOR"]={:tipo=>"String", :valor=>@invitacion.subdireccion.titular}
       #param["P_ARTICULO"]={:tipo=>"String", :valor=>"la"}
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
       send_doc_jdbc("invitacion", "invitacion", param, output_type = 'pdf')
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

  end


end
