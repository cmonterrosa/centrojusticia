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
      redirect_to :controller => "comparecencias", :action => "new_or_edit", :id => @participante.comparecencia
    else
      flash[:notice] = "No se pudo guardar, verifique"
      render :action => "new_or_edit"
    end
 end
end
