include SendDocHelper
class ComparecenciasController < ApplicationController
  require_role [:especialistas, :convenios]
  #require_role "especialistas"

  def show
    @comparecencia = Comparecencia.find(:first, :conditions => ["tramite_id = ?", params[:id]]) if params[:id]
    @tramite = (@comparecencia) ? @comparecencia.tramite : Tramite.find(params[:id]) if params[:id]
    @comparecencia ||= Comparecencia.new
    @comparecencia.tramite ||= Tramite.find(params[:id])
  end

  def new_or_edit
    redirect_to :action => "show", :id => params[:id]
  end


    def generar_pdf_involucrado
    @involucrado = Participante.find(params[:participante])
    @comparecencia = Comparecencia.find(params[:id])
    if (@involucrado && @involucrado.perfil == "INVOLUCRADO" && @comparecencia)
       #@comparecencia = Comparecencia.find(params[:id])
       param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
       #-- Parametros
       param["APP_URL"]={:tipo=>"String", :valor=>RAILS_ROOT}
       param["P_NOMBRE_INVOLUCRADO"]={:tipo=>"String", :valor=>@involucrado.nombre_completo}
       if @involucrado.edad
        (@involucrado.edad > 0) ? param["P_EDAD"]={:tipo=>"String", :valor=>"#{@involucrado.edad} AÑOS"} : param["P_EDAD"]={:tipo=>"String", :valor=>""}
       end
       param["P_SEXO"]={:tipo=>"String", :valor=>@involucrado.sexo_descripcion}
       (@involucrado.municipio) ? param["P_ORIGINARIO"]={:tipo=>"String", :valor=>@involucrado.municipio.descripcion} : ""
       param["P_DOMICILIO"]={:tipo=>"String", :valor=>@involucrado.domicilio}
       param["P_TELEFONO_CASA"]={:tipo=>"String", :valor=>@involucrado.telefono_particular}
       param["P_TELEFONO_TRABAJO"]={:tipo=>"String", :valor=>@involucrado.telefono_celular_aux}
       param["P_TELEFONO_CELULAR"]={:tipo=>"String", :valor=>@involucrado.telefono_celular}
       param["P_CORREO_ELECTRONICO"]={:tipo=>"String", :valor=>@involucrado.correo}
       param["P_OBSERVACIONES"]={:tipo=>"String", :valor=>@involucrado.observaciones}
       param["P_REFERENCIA_DOMICILIARIA"]={:tipo=>"String", :valor=>@involucrado.referencia_domiciliaria}
       param["P_ESPECIALISTA"]={:tipo=>"String", :valor=>User.find(@comparecencia.user_id).nombre_completo}
       #--- Validacion de que existe al menos un solicitante ---
       if @comparecencia.solicitante
           (@comparecencia.solicitante.nombre) ?   param["P_SOLICITANTE"]={:tipo=>"String", :valor=>@comparecencia.solicitante.nombre_completo} :    param["P_SOLICITANTE"]={:tipo=>"String", :valor=>@comparecencia.solicitante.razon_social}
       end
        #(@comparecencia.solicitante) ?   param["P_SOLICITANTE"]={:tipo=>"String", :valor=>@comparecencia.solicitante.nombre_completo} :    param["P_SOLICITANTE"]={:tipo=>"String", :valor=>" "}
        #---- Validación de tipo de persona ------
       (@involucrado.tipopersona) ?  param["P_TIPO_PERSONA"]={:tipo=>"String", :valor=>@involucrado.tipopersona.descripcion} :  param["P_TIPO_PERSONA"]={:tipo=>"String", :valor=> "" }
       (@involucrado.tipopersona.descripcion == "MORAL" && @involucrado.razon_social) ?  param["P_RAZON_SOCIAL"]={:tipo=>"String", :valor=>@involucrado.razon_social.upcase} :  param["P_RAZON_SOCIAL"]={:tipo=>"String", :valor=> " "}
        #--- Values only for moral person
        param["P_FECHA"]={:tipo=>"String", :valor=>"#{@comparecencia.fechahora.strftime('%d DE %B DE %Y').upcase}"}
         param["P_APODERADO_LEGAL"]={:tipo=>"String", :valor=>@involucrado.apoderado_legal}
        if File.exists?(REPORTS_DIR + "/involucrado.jasper")
          (@involucrado.tipopersona.descripcion == "MORAL") ? send_doc_jdbc("involucrado_persona_moral", "involucrado_persona_moral", param, output_type = 'pdf') : send_doc_jdbc("involucrado", "involucrado", param, output_type = 'pdf')
          #send_doc_jdbc("involucrado", "involucrado", param, output_type = 'pdf')
        else
          render :text => "Error"
        end


    else
      flash[:notice] = "Imposible generar reporte del involucrado, verifique parámetros"
      redirect_to :action => "show", :id => params[:id]
    end
 end




    def generar_pdf_acta_comparecencia
      @solicitante = Participante.find(params[:participante])
      if @solicitante && @solicitante.perfil == "SOLICITANTE"
        @comparecencia = Comparecencia.find(params[:id])
        param=Hash.new {|k, v| k[v] = {:tipo=>"",:valor=>""}}
        #-- Parametros
        param["APP_URL"]={:tipo=>"String", :valor=>RAILS_ROOT}
        param["P_FECHA"]={:tipo=>"String", :valor=>"#{@comparecencia.fechahora.strftime('%d DE %B DE %Y').upcase}"}
        @comparecencia.procedencia ? param["P_PROCEDENCIA"]={:tipo=>"String", :valor=>@comparecencia.procedencia.upcase} : param["P_PROCEDENCIA"]={:tipo=>"String", :valor=>"SIN INFORMACION"}
        (@solicitante.tipopersona.descripcion == "MORAL") ?  param["P_SOLICITANTE"]={:tipo=>"String", :valor=>@solicitante.apoderado_legal} :  param["P_SOLICITANTE"]={:tipo=>"String", :valor=>@solicitante.nombre_completo}
        #param["P_SOLICITANTE"]={:tipo=>"String", :valor=>@solicitante.nombre_completo}
        #param["P_EDAD"]={:tipo=>"String", :valor=>@solicitante.edad}
        if @solicitante.edad
          (@solicitante.edad > 0) ? param["P_EDAD"]={:tipo=>"String", :valor=>"#{@solicitante.edad} AÑOS"} : param["P_EDAD"]={:tipo=>"String", :valor=>""}
        end
        param["P_SEXO"]={:tipo=>"String", :valor=>@solicitante.sexo_descripcion}
        (@solicitante.municipio) ? param["P_ORIGINARIO"]={:tipo=>"String", :valor=>@solicitante.municipio.descripcion} : param["P_ORIGINARIO"]={:tipo=>"String", :valor=>""} 
        #param["P_ORIGINARIO"]={:tipo=>"String", :valor=>@solicitante.municipio.descripcion}
        @comparecencia.caracter ? param["P_CARACTER"]={:tipo=>"String", :valor=>@comparecencia.caracter.upcase} : param["P_CARACTER"]={:tipo=>"String", :valor=>"SIN INFORMACION"}
        param["P_DOMICILIO"]={:tipo=>"String", :valor=>@solicitante.domicilio}
        param["P_TELEFONO_CASA"]={:tipo=>"String", :valor=>@solicitante.telefono_particular}
        param["P_TELEFONO_TRABAJO"]={:tipo=>"String", :valor=>@solicitante.telefono_celular_aux}
        param["P_TELEFONO_CELULAR"]={:tipo=>"String", :valor=>@solicitante.telefono_celular}
        param["P_CORREO"]={:tipo=>"String", :valor=>@solicitante.correo}
        param["P_HORARIO_PREFERENCIA"]={:tipo=>"String", :valor=>@comparecencia.dia_preferencia.upcase + " (#{@comparecencia.hora_preferencia} HRS.)"}
        conocimiento = (@comparecencia.conocimiento) ? "SÍ" : "NO"
        param["P_CONOCIMIENTO"]={:tipo=>"String", :valor=>conocimiento}
        param["P_DATOS"]={:tipo=>"String", :valor=>@comparecencia.datos}
        param["P_ASUNTO"]={:tipo=>"String", :valor=>(@comparecencia.asunto).gsub(/\$/, '\$')}
        param["P_ESPECIALISTA"]={:tipo=>"String", :valor=>User.find(@comparecencia.user_id).nombre_completo}
        param["P_TIPO_PERSONA"]={:tipo=>"String", :valor=>@solicitante.tipopersona.descripcion}
        param["P_REFERENCIA_DOMICILIARIA"]={:tipo=>"String", :valor=>@solicitante.referencia_domiciliaria}
        #--- params only for moral person ---
        param["P_APODERADO_LEGAL"]={:tipo=>"String", :valor=>@solicitante.apoderado_legal}
        param["P_RAZON_SOCIAL"]={:tipo=>"String", :valor=>@solicitante.razon_social}
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
       @comparecencia.update_attributes(params[:comparecencia])
    else
      @tramite.update_estatus!("comp-conc", current_user) # update estatus of tramite
      #NotificationsMailer.deliver_tramite_created(@tramite, @tramite.user) # sends the email
      @comparecencia = Comparecencia.new(params[:comparecencia])
      @comparecencia.tramite = @tramite
    end
    @comparecencia.user = current_user
    if @comparecencia.save
       @tramite.generar_folio_expediente!
      flash[:notice] = "Guardado correctamente"
      #redirect_to :controller => "tramites", :action => "menu", :id => @tramite
       #render :action => "new_or_edit"
       redirect_to :action => "show", :id => @tramite
    else
      flash[:notice] = "No se pudo guardar, verifique"
     # render :action => "new_or_edit"
       render :action => "show_informacion_general"
    end
  end


  def list_by_user
    @user = current_user
    @estatus = Estatu.find_by_clave("comp-conc")
    @comparecencias = Comparecencia.find(:all,
                                       :select => ["c.*"],
                                       :joins => ["c, tramites t"],
                                       :conditions => ["c.tramite_id = t.id AND c.user_id = ? AND t.estatu_id = ?", @user.id, @estatus.id],
                                       :order => "c.fechahora")
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
end
