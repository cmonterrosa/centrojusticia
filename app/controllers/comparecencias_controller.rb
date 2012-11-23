class ComparecenciasController < ApplicationController
  require_role "especialistas"

  def show
    @comparecencia = Comparecencia.find(:first, :conditions => ["tramite_id = ?", params[:id]]) if params[:id]
    @tramite = (@comparecencia) ? @comparecencia.tramite : Tramite.find(params[:id]) if params[:id]
    @comparecencia ||= Comparecencia.new
    @comparecencia.tramite ||= Tramite.find(params[:id])
  end

  def new_or_edit
    redirect_to :action => "show", :id => params[:id]
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
