include SendDocHelper
class InvitacionesController < ApplicationController
  def index
  end



  def generar
    #@sesion = Sesion.find(params[:id])
    #
    @sesion = Sesion.find(params[:id])
    @tramite = @sesion.tramite
    @orientacion = Orientacion.find_by_tramite_id(@tramite.id)
    #
    #@participante = Participante.find_by_comparecencia_id(@sesion.tramite.comparecencia.id)
    param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
    param["P_NOMBRE"]={:tipo=>"String", :valor=>"Carlos Augusto Monterrosa López"}
    param["P_ESPECIALISTA"]={:tipo=>"String", :valor=>"Lic. Amauri Palacios Aquino"}
    param["P_SUBDIRECTOR"]={:tipo=>"String", :valor=>"Rodrigo Domínguez Moscoso"}
    param["P_ARTICULO"]={:tipo=>"String", :valor=>"la"}
    param["P_LUGAR"]={:tipo=>"String", :valor=>"Tuxtla Gutiérrez, Chiapas;"}
    param["P_FECHA"]={:tipo=>"String", :valor=>"21 de Diciembre de 2012"}
    param["P_SOLICITANTE"]={:tipo=>"String", :valor=>"C. Norma Espinoza Vázquez"}
    param["P_FECHA_ORIENTACION"]={:tipo=>"String", :valor=>"17 de febrero de 2012"}
    param["P_FECHA_SESION"]={:tipo=>"String", :valor=>"05 de marzo, a las 3 de la tarde"}

    send_doc_jdbc("invitacion", "invitacion", param, output_type = 'pdf')

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
    @invitaciones= (@sesiones.empty?)? nil :  Invitacion.find(:all, :conditions => ["sesion_id in ?", @sesiones.collect{|s| s.id}])
    #@invitaciones = Invitacion.find(:all, :conditions => ["sesion_id in ?", @sesiones.collect{|s| s.id}])
  end

  def list_by_person

  end


end
