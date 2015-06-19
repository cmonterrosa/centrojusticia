class ProcedenciasController < ApplicationController
  require_role [:admindireccion, :oficinasubdireccion]
  
  layout 'kolaval'

  # GET /procedencias
  # GET /procedencias.xml
  def index
    @procedencias = Procedencia.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @procedencias }
    end
  end

  # GET /procedencias/1
  # GET /procedencias/1.xml
  def show
    @procedencia = Procedencia.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @procedencia }
    end
  end

  # GET /procedencias/new
  # GET /procedencias/new.xml
  def new
    @procedencia = Procedencia.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @procedencia }
    end
  end

  # GET /procedencias/1/edit
  def edit
    @procedencia = Procedencia.find(params[:id])
  end

  # POST /procedencias
  # POST /procedencias.xml
  def create
    @procedencia = Procedencia.new(params[:procedencia])

    respond_to do |format|
      if @procedencia.save
        format.html { redirect_to(@procedencia, :notice => 'Registro creado correctamente.') }
        format.xml  { render :xml => @procedencia, :status => :created, :location => @procedencia }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @procedencia.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /procedencias/1
  # PUT /procedencias/1.xml
  def update
    @procedencia = Procedencia.find(params[:id])

    respond_to do |format|
      if @procedencia.update_attributes(params[:procedencia])
        format.html { redirect_to(@procedencia, :notice => 'Registro actualizado correctamente.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @procedencia.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /procedencias/1
  # DELETE /procedencias/1.xml
  def destroy
    @procedencia = Procedencia.find(params[:id])
    @extraordinarias = Extraordinaria.count(:id, :conditions => ["procedencia_id = ?", @procedencia.id])
    if @extraordinarias < 1
      if @procedencia.destroy 
        flash[:notice] = "Registro eliminado correctamente"
      end
    else
      flash[:error] = "No se pudo eliminar porque tiene registros asociados"
    end

    respond_to do |format|
      format.html { redirect_to(procedencias_url) }
      format.xml  { head :ok }
    end
  end
end
