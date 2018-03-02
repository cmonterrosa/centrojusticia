class VisitaController < ApplicationController
	require_role [:librocontrol, :visitadores, :direccion]

	def index
		@inicio = @fin = Time.now
	end

	def visita
			#--- creamos nuevo objeto -----      
			#@inicio = @fin = Time.now
      @visita ||= Visita.new
    	@visita.update_attributes(params[:visita])
    	@visita.user_id = current_user.id
    	@visita.estatus_visita_id = 1        
    	@visita.periodo_fin = (@visita.periodo_inicio==@visita.periodo_fin) ? @visita.periodo_fin + 86340 : @visita.periodo_fin
    	@inicio, @fin = @visita.periodo_inicio, @visita.periodo_fin + 86340
          	   	

      if @visita.save
        flash[:notice] = "Registro guardado correctamente"
        #redirect_to :action => "list_by_user", :controller => "orientacions"
        #redirect_to :action => "search", :controller => "libro", :fecha_inicio => @visita.periodo_inicio, :fecha_fin => @visita.periodo_fin

        #params[:periodo_fin] = (params[:periodo_inicio]==params[:periodo_fin]) ? params[:periodo_fin] + " 23:59" : params[:periodo_fin]

    		#@inicio, @fin = DateTime.parse(params[:periodo_inicio]), DateTime.parse(params[:periodo_fin] + " 23:59")
    		

        @tramites = Tramite.find(:all, :conditions => ["(anio IS NOT NULL AND anio between ? AND ? )
      	AND (folio_expediente IS NOT NULL)
      	AND (fechahora between ? AND ?)", @inicio.year, @fin.year, @inicio, @fin],
      	:order => "anio, folio_expediente")
    		@tramites = @tramites.paginate(:page => params[:page], :per_page => 25)
      else
        flash[:error] = "no se pudo guardar el registro, verifique"
        render :action => "visita"
      end
	end


	def calcelar_visita
		if @visita = Visita.find(params[:id])
       @visita.update_attributes!(params[:tramite])
       (@tramite.cancel(current_user))? flash[:notice] = "Trámite cancelado" : flash[:notice] = "No se pudo cancelar el trámite"       
       return render(:partial => 'success_cancel', :layout => "only_jquery")
    else
       return render(:partial => 'failed_cancel', :layout => "only_jquery")
    end
	end

	def finalizar_visita
		if @visita = Visita.find(params[:id])
			@visita.update_attributes(:estatus_visita_id => 2, :fechahora_fin => Time.now)
			@inicio = @fin = Time.now
			render :action => "index"
		else
			flash[:error] = "no se pudo guardar el registro, verifique"
      render :action => "index"
		end
	end

	def imprimir_dictamen
		@visita = Visita.find(params[:id])
		param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
        param["APP_URL"]={:tipo=>"String", :valor=>RAILS_ROOT}
        param["P_SUBDIRECCION"]={:tipo=>"String", :valor=>SUBDIRECCION}
        param["P_VISITADOR"]={:tipo=>"String", :valor=> @visita.user.nombre_completo}
        param["P_EXPEDIENTE"]={:tipo=>"String", :valor=> @visita.user_id}
        param["P_INICIO"]={:tipo=>"String", :valor=> @visita.created_at.strftime("%d de %B de %Y")}
        param["P_FIN"]={:tipo=>"String", :valor=> @visita.periodo_fin.strftime("%d de %B de %Y")}
        param["P_PERINICIO"]={:tipo=>"String", :valor=>@visita.periodo_inicio.strftime("%d de %B de %Y")}
        #param["P_PERFIN"]={:tipo=>"String", :valor=>"#{fecha_string(Time.now)}"}
        param["P_PERFIN"]={:tipo=>"String", :valor=>Time.now.strftime("%d de %B de %Y")}
        param["P_TIPOVISITA"]={:tipo=>"String", :valor=> @visita.tipovisita.descripcion}
        param["P_EXPINI"]={:tipo=>"String", :valor=> @visita.periodo_inicio}
        param["P_EXPFIN"]={:tipo=>"String", :valor=> @visita.periodo_fin}
        param["P_OBSERVACIONES"]={:tipo=>"String", :valor=> @visita.observaciones}

        if File.exists?(REPORTS_DIR + "/dictamen_visita.jasper")
          send_doc_jdbc("dictamen_visita", "dictamen_visita", param, output_type = 'pdf')
        else
          render :text => "Error"
        end

	end
end
