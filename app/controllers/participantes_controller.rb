class ParticipantesController < ApplicationController
  def new_or_edit_persona_fisica
     @participante = Participante.new if params[:token]
     @participante = Participante.find(params[:participante]) if params[:participante]
     @participante ||= Participante.new
     #@participante.anio_nac = (Time.now.year.to_i - @participante.anio_nac.to_i) if  @participante.anio_nac
     @comparecencia = Comparecencia.find(params[:id])
     @tipo_persona = Tipopersona.find_by_descripcion("FISICA")
  end
  
   def new_or_edit_persona_moral
     @participante = Participante.new if params[:token]
     @participante = Participante.find(params[:participante]) if params[:participante]
     @participante ||= Participante.new
     @comparecencia = Comparecencia.find(params[:id])
     @tipo_persona = Tipopersona.find_by_descripcion("MORAL")
  end



  def save
    if Participante.exists?(params[:participante_id])
        @participante =  Participante.find(params[:participante_id])
        @participante.update_attributes(params[:participante])
    end
    @participante ||= Participante.new(params[:participante])
    @participante.comparecencia = Comparecencia.find(params[:id])
    @participante.user = current_user
    if @participante.save
      flash[:notice] = "Guardado correctamente"
      redirect_to :controller => "comparecencias", :action => "new_or_edit", :id => @participante.comparecencia.tramite
    else
      flash[:notice] = "No se pudo guardar, verifique"
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
            flash[:notice] = "No se pudo eliminar, verifique"
            render :action => "new_or_edit"
        end
    end
  end

  def show
    if Participante.exists?(params[:id])
        @participante =  Participante.find(params[:id])
        @tramite = @participante.comparecencia.tramite
    end
  end

end
