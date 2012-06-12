class OrientacionsController < ApplicationController
  # GET /orientacions
  # GET /orientacions.xml

  def menu
    
  end

  def list_by_user
    @user = current_user
    @orientaciones = Orientacion.find(:all, :conditions => ["user_id = ?", @user.id])
  end

  def change_estatus
    @orientacion = Orientacion.find(params[:id])
    @orientacion.estatu = Estatu.find_by_descripcion(params[:token])
    if @orientacion.save
        flash[:notice] = "Estatus de orientación cambiado correctamente"
    else
        flash[:notice] = "No se puedo cambiar estatus, verifique"
    end
    redirect_to :action => "list_by_user"
  end

  def new_or_edit
    @orientacion ||= Orientacion.new
    @especialistas =  Role.find(:first, :conditions => ["name = ?", 'especialistas']).users
  end

   def save
    @orientacion = Orientacion.new(params[:orientacion])
    if @orientacion.save
      flash[:notice] = "Guardado correctamente"
      redirect_to :action => "menu"
    else
      flash[:notice] = "No se pudo guardar, verifique"
      render :action => "new_or_edit"
    end
   end


  def index
    @orientacions = Orientacion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orientacions }
    end
  end

  # GET /orientacions/1
  # GET /orientacions/1.xml
  def show
    @orientacion = Orientacion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @orientacion }
    end
  end

  # GET /orientacions/new
  # GET /orientacions/new.xml
  def new
    @orientacion = Orientacion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @orientacion }
    end
  end

  # GET /orientacions/1/edit
  def edit
    @orientacion = Orientacion.find(params[:id])
  end

  # POST /orientacions
  # POST /orientacions.xml
  def create
    @orientacion = Orientacion.new(params[:orientacion])

    respond_to do |format|
      if @orientacion.save
        format.html { redirect_to(@orientacion, :notice => 'Orientacion was successfully created.') }
        format.xml  { render :xml => @orientacion, :status => :created, :location => @orientacion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @orientacion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /orientacions/1
  # PUT /orientacions/1.xml
  def update
    @orientacion = Orientacion.find(params[:id])

    respond_to do |format|
      if @orientacion.update_attributes(params[:orientacion])
        format.html { redirect_to(@orientacion, :notice => 'Orientacion was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @orientacion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orientacions/1
  # DELETE /orientacions/1.xml
  def destroy
    @orientacion = Orientacion.find(params[:id])
    @orientacion.destroy

    respond_to do |format|
      format.html { redirect_to(orientacions_url) }
      format.xml  { head :ok }
    end
  end
end
