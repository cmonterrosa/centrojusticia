include SendDocHelper
class LibroController < ApplicationController
  require_role [:librocontrol, :visitadores, :direccion, :subdireccion]
  
  def index
    @inicio = @fin = Time.now
  end

  def search
    params[:fecha_fin] = (params[:fecha_inicio]==params[:fecha_fin]) ? params[:fecha_fin] + " 23:59" : params[:fecha_fin]
    @inicio, @fin = DateTime.parse(params[:fecha_inicio]), DateTime.parse(params[:fecha_fin] + " 23:59")
    
    @razonapertura = Cierreanio.find(:first, :conditions =>["fecha between ? and ? and tipo_razon='APERTURA'",@inicio, @fin])
    @razoncierre = Cierreanio.find(:first, :conditions =>["fecha between ? and ? and tipo_razon='CIERRE'",@inicio, @fin])
    if @razonapertura
      @mensajeapertura = "EL SUSCRITO #{User.find_by_id(@razonapertura.user_id).nombre_completo}, #{@razonapertura.cargo} DEL CENTRO ESTATAL DE JUSTICIA ALTERNATIVA DEL TRIBUNAL SUPERIOR DE JUSTICIA DEL
ESTADO DE CHIAPAS, DE CONFORMIDAD CON LO DISPUESTO POR EL ARTÍCULO 28 DE LA LEY DE JUSTICIA ALTERNATIVA DEL ESTADO DE CHIAPAS Y 16 DE SU REGLAMENTO, HAGO
CONSTAR QUE CON FECHA #{@razonapertura.fecha.strftime("%d de ")} #{Date::MONTHNAMES[@razonapertura.fecha.month].downcase} de #{@razonapertura.fecha.year}, SE PROCEDE A LA APERTURA DEL LIBRO ELECTRÓNICO DEL SISTEMA INFORMÁTICO KOLAVAL, CORRESPONDIENTE AL
AÑO JUDICIAL #{@razonapertura.fecha.year}. DOY FE."
    else
      @mensajeapertura = nil
    end

    if @razoncierre
      @mensajecierre = "EL SUSCRITO #{User.find_by_id(@razoncierre.user_id).nombre_completo}, #{@razoncierre.cargo} DEL CENTRO ESTATAL DE JUSTICIA ALTERNATIVA DEL TRIBUNAL SUPERIOR DE JUSTICIA DEL
ESTADO DE CHIAPAS, DE CONFORMIDAD CON LO DISPUESTO POR EL ARTÍCULO 28 DE LA LEY DE JUSTICIA ALTERNATIVA DEL ESTADO DE CHIAPAS Y 16 DE SU REGLAMENTO, HAGO
CONSTAR QUE CON FECHA #{@razoncierre.fecha.strftime("%d de ")} #{Date::MONTHNAMES[@razoncierre.fecha.month].downcase} de #{@razoncierre.fecha.year}, SE PROCEDE AL CIERRE DEL LIBRO ELECTRÓNICO DEL SISTEMA INFORMÁTICO KOLAVAL, CORRESPONDIENTE AL
AÑO JUDICIAL #{@razoncierre.fecha.year}. DOY FE."
    else
      @mensajecierre = nil
    end


    @tramites = Tramite.find(:all, :conditions => ["(anio IS NOT NULL AND anio between ? AND ? )
      AND (folio_expediente IS NOT NULL)
      AND (fechahora between ? AND ?)", @inicio.year, @fin.year, @inicio, @fin],
      :order => "anio, folio_expediente")
    @tramites = @tramites.paginate(:page => params[:page], :per_page => 25)
  end


  def imprimir
        params[:fecha_fin] = (params[:fecha_inicio]==params[:fecha_fin]) ? params[:fecha_fin] + " 23:59" : params[:fecha_fin]
        @inicio, @fin = DateTime.parse(params[:fecha_inicio]), DateTime.parse(params[:fecha_fin] + " 23:59")
        @tramites = Tramite.find(:all, :conditions => ["((anio IS NOT NULL AND anio = ? ) AND folio_expediente IS NOT NULL) AND (created_at between ? AND ?)", @inicio.year, @inicio, @fin], :order => "anio, folio_expediente")
        @ids_tramites = @tramites.collect{|i|i.id}
        param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
        param["APP_URL"]={:tipo=>"String", :valor=>RAILS_ROOT}
        #param["TRAMITES"]={:tipo=>"String", :valor=> @ids_tramites.join(",")}
        param["P_ANIO"]={:tipo=>"String", :valor=> @inicio.year}
        param["P_INICIO"]={:tipo=>"String", :valor=> @inicio}
        param["P_FIN"]={:tipo=>"String", :valor=> @fin}
        param["P_SUBDIRECCION"]={:tipo=>"String", :valor=>SUBDIRECCION}
        param["P_FECHA"]={:tipo=>"String", :valor=>"#{fecha_string(Time.now)}"}

        if File.exists?(REPORTS_DIR + "/librook.jasper")
          send_doc_jdbc("librook", "librook", param, output_type = 'pdf')
        else
          render :text => "Error"
        end
    
   end   




end

