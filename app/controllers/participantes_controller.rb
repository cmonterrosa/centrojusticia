class ParticipantesController < ApplicationController
  def new_or_edit_persona_fisica
     @participante = Participante.new if params[:token]
     @participante = Participante.find(params[:participante]) if params[:participante]
     @participante ||= Participante.new
     #@participante.anio_nac = (Time.now.year.to_i - @participante.anio_nac.to_i) if  @participante.anio_nac
     @comparecencia = Comparecencia.find(params[:id])
     @tipo_persona = Tipopersona.find_by_descripcion("FISICA")
     ## Recibe dato de edicion desde invitacion ###
     @invitacion = (params[:origin] && params[:origin] == 'invitaciones') ? 1 : false
     @sesion = (params[:sesion])? params[:sesion] : false if @invitacion
  end
  
  def new_or_edit_persona_moral
     @participante = Participante.new if params[:token]
     @participante = Participante.find(params[:participante]) if params[:participante]
     @participante ||= Participante.new
     @comparecencia = Comparecencia.find(params[:id])
     @tipo_persona = Tipopersona.find_by_descripcion("MORAL")
     ## Recibe dato de edicion desde invitacion ###
     @invitacion = (params[:origin] && params[:origin] == 'invitaciones') ? 1 : false
     @sesion = (params[:sesion])? params[:sesion] : false if @invitacion
  end

  def new_or_edit_existente
    @comparecencia = Comparecencia.find(params[:id])
    @tramite = @comparecencia.tramite
  end

  def save
    if Participante.exists?(params[:participante_id])
        @participante =  Participante.find(params[:participante_id])
        @participante.update_attributes(params[:participante])
    end
    @participante ||= Participante.new(params[:participante])
    @participante.comparecencia = Comparecencia.find(params[:id])

    ## Si no sabe o no respondio edad y procedencia ###
    (@participante.sabe_edad && @participante.sabe_edad == 'NO')? @participante.fecha_nac=nil : nil
    (@participante.sabe_edad && @participante.sabe_edad == 'NO')? @participante.anio_nac=nil : nil
    (@participante.sabe_procedencia && @participante.sabe_procedencia == 'NO')? (@participante.municipio_id=nil) : nil
    ## Origen etnico ###
    (params[:participante][:pertenece_grupo_etnico ]== 'SI')? @participante.pertenece_grupo_etnico = true : nil
    (params[:participante][:pertenece_grupo_etnico] == 'NO')? @participante.etnia=nil : nil
    @participante.user = current_user
    url_regreso = (params[:invitacion] && params[:sesion]) ? {:action => "list_by_sesion", :controller => "invitaciones", :id => params[:sesion]} : {:controller => "comparecencias", :action => "new_or_edit", :id => @participante.comparecencia.tramite}
    if @participante.save
      flash[:notice] = "Guardado correctamente"
      redirect_to url_regreso
    else
      flash[:error] = "No se pudo guardar, verifique"
      render :action => "new_or_edit"
    end
 end

  def delete
    if Participante.exists?(params[:id])
        @participante =  Participante.find(params[:id])
        @tramite = @participante.comparecencia.tramite
        if @participante.destroy
            flash[:notice] = "Participante eliminado correctamente"
            redirect_to :controller => "comparecencias", :action => "new_or_edit", :id => @tramite
        else
            flash[:error] = "No se pudo eliminar, verifique"
            render :action => "new_or_edit"
        end
    end
  end

  def show
    if Participante.exists?(params[:id])
        @participante =  Participante.find(params[:id])
        @tramite = @participante.comparecencia.tramite
        render :partial => "show", :layout => "only_jquery"
    end
  end

  def search
     if params[:search] && params[:search].size > 4
      @participantes = Participante.search(params[:search])
      @total_resultados = @participantes.size
      @participantes = @participantes.paginate(:page => params[:page], :per_page => 25)
      @comparecencia = Comparecencia.find(params[:comparecencia])
      render :partial => "resultados_busqueda", :layout => 'kolaval'
     else
      redirect_to(:back)
     end
  end

  def add
    @comparecencia = Comparecencia.find(params[:comparecencia])
    @participante = Participante.find(params[:id])
    @nuevo_participante = @participante.clone
    @nuevo_participante.comparecencia_id = @comparecencia
    @nuevo_participante.perfil = (params[:t] && params[:t] == 's') ? 'SOLICITANTE' : 'INVOLUCRADO'
    @nuevo_participante.observaciones = ""
    @nuevo_participante.created_at = Time.now
    if @comparecencia.participantes << @nuevo_participante
      flash[:notice] = "Participante agregado correctamente"
    else
      flash[:error] = "No se pudo agregar participante"
    end
      redirect_to :action => "show", :controller => "comparecencias", :id => @comparecencia.tramite
  end


end
