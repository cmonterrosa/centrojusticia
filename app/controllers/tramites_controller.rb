class TramitesController < ApplicationController
  before_filter :login_required
  require_role "especialistas", :for => [:menu]


  def index
  end

  def list
    @estatus_unicos = Estatu.find_by_sql(["select distinct(estatu_id) as id from estatus_roles where role_id in (?)", current_user.roles])
    @tramites = Tramite.find(:all, :conditions => ["estatu_id in (?)", @estatus_unicos], :order => "created_at DESC")
   end

  def show
    unless @tramite=Tramite.find(params[:id])
      flash[:notice] = "No se encontro trámite, verifique"
      redirect_back_or_default('/')
    end
  end

  def menu
    unless @tramite=Tramite.find(params[:id])
      flash[:notice] = "No se encontro trámite, verifique"
      redirect_back_or_default('/')
    end
  end


  def save
      #---- Si existe registro previo ---
      @comparecencia = Comparecencia.find(params[:id])
      @expediente = @comparecencia.expediente
      @expediente.update_attributes(params[:expediente]) if @expediente
      #--- creamos nuevo objeto -----
      @expediente ||= Tramite.new(params[:expediente])
      #----- establecemos parametros de control ---
      @expediente.user = current_user
      @expediente.anio = params[:expediente]["fechahora(1i)"].to_i
      @expediente.folio = generar_folio(@expediente.anio) unless @expediente.folio
      @expediente.comparecencia = @comparecencia
      if @expediente.save
        flash[:notice] = "Registro guardado correctamente"
        redirect_to :action => "list_by_user", :controller => "orientacions"
      else
        flash[:notice] = "no se pudo guardar el registro, verifique"
        render :action => "asignar_materia"
      end
  end

 #---- actualización de estatus ----
  def update_estatus
    @tramite = Tramite.find(params[:id])
    #---- excepciones -----
      if params[:new_st]
        case Estatu.find(params[:new_st]).clave
            when "comp-conc" #--- levantar comparecencia --
              redirect_to :action => "new_or_edit", :controller => "comparecencias", :id => @tramite
            when "mate-asig" #--- asignacion de materia --
              return render(:partial => 'asignacion_materia', :layout => "oficial")
            when "espe-asig" #--- asignacion de especialista --
               session["tramite_id"] = @tramite.id
                @users = @tramite.materia.users
                return render(:partial => 'asignacion_especialista', :layout => "oficial")
            when "fech-asig" #---- asignacion de fecha y hora de sesión ----
                return render(:partial => 'asignacion_fecha_hora_sesion', :layout => "oficial")
            else
              update_tramite_model
         end
      else
          if params[:tramite]
            @tramite.update_attributes(params[:tramite])
            update_tramite_model
          end
          if params[:sesion]
            @sesion = Sesion.new(params[:sesion])
            @sesion.tramite = Tramite.find(params[:id])
            @sesion.save
            update_tramite_model
          end
          
      end
  end

  def search
    if params[:q] && params[:q] =~ /\d+/
      if @tramite = Tramite.find(:first, :conditions => ["id = ? or folio = ?", params[:q], params[:q]])
         redirect_to :action => "show", :id => @tramite
      else
         flash[:notice] = "No se encontraron resultados, verifique"
         redirect_back_or_default('/')
      end
    else
      flash[:notice] = "No se pudo realizar la búsqueda, verifique"
      redirect_back_or_default('/')
     end
  end

   #----- filtros ajax --------
  def filtro_estatus
    if params[:estatu_id].size > 0
      @estatu = Estatu.find(params[:estatu_id])
      @tramites = Tramite.find(:all, :conditions => ["estatu_id = ?", @estatu.id], :order => "created_at DESC") if @estatu
    end
     @estatus_unicos = Estatu.find_by_sql(["select distinct(estatu_id) as id from estatus_roles where role_id in (?)", current_user.roles])
     @tramites ||= Tramite.find(:all, :conditions => ["estatu_id in (?)", @estatus_unicos], :order => "created_at DESC")
    return render(:partial => 'listajaxbasic', :layout => false) if request.xhr?
  end

  def get_comediador
      @users = []
      @sesion = Sesion.new
      @mediador = User.find(params[:sesion_mediador_id])
      Tramite.find(session["tramite_id"]).materia.users.each{|user|@users << user unless user.id == @mediador.id}
      return render(:partial => 'comediadores', :layout => false) if request.xhr?
  end

protected
  def generar_folio(anio)
    maximo=  Tramite.maximum(:folio, :conditions => ["anio = ?", anio])
    folio = 1 unless maximo
    folio ||= maximo+1
  end

  def update_tramite_model
     if @tramite.update_flujo_estatus!(current_user)
        flash[:notice] = "Registro actualizado correctamente"
     else
        flash[:notice] = "No se pudo guardar, verifique"
     end
     redirect_to :action => "list"
  end

end
