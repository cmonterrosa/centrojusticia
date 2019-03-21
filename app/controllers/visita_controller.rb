class VisitaController < ApplicationController
	require_role [:librocontrol, :visitadores, :direccion, :subdireccion]

	def index
		@inicio = @fin = Time.now
	end

	def visita
			#--- creamos nuevo objeto -----      			
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
        redirect_to :action => "list_tramites", :controller => "visita", :id => @visita.id, :ini => @visita.periodo_inicio, :final => @visita.periodo_fin

        #params[:periodo_fin] = (params[:periodo_inicio]==params[:periodo_fin]) ? params[:periodo_fin] + " 23:59" : params[:periodo_fin]
    		#@inicio, @fin = DateTime.parse(params[:periodo_inicio]), DateTime.parse(params[:periodo_fin] + " 23:59")   		
        
      else
        flash[:error] = "no se pudo guardar el registro, verifique"
        render :action => "visita"
      end
	end

	def list_tramites
		if @visita = Visita.find(params[:id])
			#@inicio = Date.parse(params[:ini])
			#@fin = Date.parse(params[:final])
			@inicio = @visita.periodo_inicio
			@fin = @visita.periodo_fin

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
  		@visitaid = params[:id] 
		else
			flash[:error] = "no se pudo guardar el registro, verifique"
      render :action => "visita"
		end  	
	end


	def list
		@visitas = Visita.find(:all, :order => "created_at DESC, id DESC").paginate(:page => params[:page], :per_page => 25) 
		#@tramites = (current_user.has_role?(:convenios) || current_user.has_role?(:jefeconvenios))? Tramite.find(:all, :conditions => ["estatu_id in (?)", @estatus_unicos], :order => "anio DESC, folio_expediente DESC, fechahora DESC").paginate(:page => params[:page], :per_page => 25) : nil
    #@tramites ||= (current_user.has_role?("atencionpublico"))? Tramite.find(:all, :conditions => ["estatu_id in (?)", @estatus_unicos], :order => "fechahora DESC").paginate(:page => params[:page], :per_page => 25) : Tramite.find(:all, :conditions => ["estatu_id in (?)", @estatus_unicos], :order => "anio DESC, folio_expediente DESC, fechahora DESC").paginate(:page => params[:page], :per_page => 25)

	end

	def agregar_participante
    #@visita = Visita.find(params[:visita])
    #@visita.participantevisitas << Role.find(params[:role][:role_id])
    @participante = Participantevisita.new
    @participante.visita_id = params[:visita]
    @participante.user_id = params[:participantevisita][:user_id]
    @participante.tipoparticipantevisita_id = 1
    if @participante.save
      flash[:notice] = "Perfil agregado correctamente al usuario"
    else
      flash[:error] = "El perfil no fue agregado al usuario"
    end
      redirect_to :action => "resumen", :id => params[:visita]
	end

	def quitar_participante
	  @participante = Participantevisita.find(params[:id])
	  #@user = User.find(params[:id])
	  @participante.delete()
	   if @participante.save!
	     flash[:notice] = "Elemento eliminado del perfil correctamente"
	   else
	     flash[:error] = "No se pudo eliminar, verifique"
	   end
	    redirect_to :action => "resumen", :id => params[:visita]
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
			#render :action => "resumen"
			redirect_to :action => "resumen", :controller => "visita", :id => @visita.id
		else
			flash[:error] = "no se pudo guardar el registro, verifique"
      render :action => "index"
		end
	end

	def resumen
		@visita = Visita.find(params[:id])
		@participantes = @visita.participantevisitas    
    @visitadores = Role.find_by_name('visitadores').users
	end

	def imprimir_dictamen
		@visita = Visita.find(params[:id])
    @participantesvisitas = Participantevisita.find(:all, :conditions => ["visita_id=?", @visita.id])
    @parts = @participantesvisitas.map{|i|("#{i.user.nombre_completo}")}.join(" <br/>")
		param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
        param["APP_URL"]={:tipo=>"String", :valor=>RAILS_ROOT}
        param["P_SUBDIRECCION"]={:tipo=>"String", :valor=>SUBDIRECCION}
        param["P_VISITADOR"]={:tipo=>"String", :valor=> @visita.user.nombre_completo}
        param["P_EXPEDIENTE"]={:tipo=>"String", :valor=> @visita.id}
        param["P_INICIO"]={:tipo=>"String", :valor=> @visita.fechahora_inicio.strftime("%d de %B de %Y")}
        param["P_FIN"]={:tipo=>"String", :valor=> @visita.fechahora_fin.strftime("%d de %B de %Y")}
        param["P_PERINICIO"]={:tipo=>"String", :valor=>@visita.periodo_inicio.strftime("%d de %B de %Y")}  
        param["P_PERFIN"]={:tipo=>"String", :valor=>@visita.periodo_fin.strftime("%d de %B de %Y")}
        param["P_TIPOVISITA"]={:tipo=>"String", :valor=> @visita.tipovisita.descripcion}
        param["P_EXPINI"]={:tipo=>"String", :valor=> @visita.periodo_inicio}
        param["P_EXPFIN"]={:tipo=>"String", :valor=> @visita.periodo_fin}
        param["P_OBSERVACIONES"]={:tipo=>"String", :valor=> @visita.observaciones}
        param["P_PARTICIPANTES"]={:tipo=>"String", :valor=> @parts}

        if File.exists?(REPORTS_DIR + "/dictamen_visita.jasper")
          send_doc_jdbc("dictamen_visita", "dictamen_visita", param, output_type = 'pdf')
        else
          render :text => "Error"
        end

	end
end
