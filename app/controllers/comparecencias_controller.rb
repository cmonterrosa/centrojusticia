class ComparecenciasController < ApplicationController

  def new_or_edit
    @comparecencia = Comparecencia.find(:first, :conditions => ["tramite_id = ?", params[:id]])
    @comparecencia ||= Comparecencia.new
    @comparecencia.tramite ||= Tramite.find(params[:id])
    @dias = {'Lunes' => 1, 'Martes' => 2, 'Miercoles' => 3, 'Jueves' => 4, 'Viernes' => 5, 'Sábados' => 6}
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
      flash[:notice] = "Guardado correctamente"
      redirect_to :controller => "orientacions", :action => "list_by_user"
    else
      flash[:notice] = "No se pudo guardar, verifique"
      render :action => "new_or_edit"
    end
  end

end
