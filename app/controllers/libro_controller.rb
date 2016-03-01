class LibroController < ApplicationController
  require_role [:librocontrol, :visitadores, :direccion, :subdireccion]
  
  def index
    @inicio = @fin = Time.now
  end

  def search
    params[:fecha_fin] = (params[:fecha_inicio]==params[:fecha_fin]) ? params[:fecha_fin] + " 23:59" : params[:fecha_fin]
    @inicio, @fin = DateTime.parse(params[:fecha_inicio]), DateTime.parse(params[:fecha_fin] + " 23:59")
#    @tramites = Tramite.find(:all,
#                              :select => "tramites.*",
#                              :joins => "tramites, orientacions orientacions, estatus e",
#                              :conditions => ["orientacions.tramite_id=tramites.id AND tramites.estatu_id=e.id AND e.clave in ('comp-conc', 'no-compar', 'tram-escr', 'mate-asig', 'fecha-asig', 'camb-sesi', 'tram-conc', 'meca-asig', 'en-sesion') AND (orientacions.fechahora between ? AND ?)", @inicio, @fin],
#                              :order => ["tramites.fechahora DESC, tramites.folio_expediente"])

    @tramites = Tramite.find(:all, :conditions => ["((anio IS NOT NULL AND anio = ? ) AND folio_expediente IS NOT NULL) AND (created_at between ? AND ?)", @inicio.year, @inicio, @fin], :order => "anio, folio_expediente")
    @tramites = @tramites.paginate(:page => params[:page], :per_page => 25)
  end

end
