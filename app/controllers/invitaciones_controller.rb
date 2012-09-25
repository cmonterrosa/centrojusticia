include SendDocHelper
class InvitacionesController < ApplicationController
  def index
  end

  def generar
    #@sesion = Sesion.find(params[:id])
    #@participante = Participante.find_by_comparecencia_id(@sesion.tramite.comparecencia.id)
    send_doc_jdbc("invitacion", "invitacion", params, output_type = 'pdf')

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
