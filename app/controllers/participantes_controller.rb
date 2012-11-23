class ParticipantesController < ApplicationController
  def new_or_edit
     @participante = Participante.new if params[:token]
     @participante = Participante.find(params[:participante]) if params[:participante]
     @participante ||= Participante.new
     @comparecencia = Comparecencia.find(params[:id])
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

end
