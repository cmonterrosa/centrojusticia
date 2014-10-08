class EmpleadosController < ApplicationController
  require_role [:admin, :capacitacion, :direccion]
  layout :set_layout

  # GET /empleados
  # GET /empleados.xml
  def index
    @empleados = Empleado.find(:all, :order => "paterno").paginate(:page => params[:page], :per_page => 25)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @empleados }
    end
  end

  # GET /empleados/1
  # GET /empleados/1.xml
  def show
    @empleado = Empleado.find(params[:id])
    @formacions = Formacion.find(:all, :conditions => ["empleado_id = ?", @empleado], :order => "fecha_conclusion")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @empleado }
    end
  end

  def show_pdf
    @empleado = Empleado.find(params[:id])
    @formacions = Formacion.find(:all, :conditions => ["empleado_id = ?", @empleado], :order => "fecha_conclusion")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @empleado }
    end
  end

  # GET /empleados/new
  # GET /empleados/new.xml
  def new
    @empleado = Empleado.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @empleado }
    end
  end

  # GET /empleados/1/edit
  def edit
    @empleado = Empleado.find(params[:id])
  end

  # POST /empleados
  # POST /empleados.xml
  def create
    @empleado = Empleado.new(params[:empleado])

    respond_to do |format|
      if @empleado.save
        format.html { redirect_to(@empleado, :notice => 'Empleado creado correctamente') }
        format.xml  { render :xml => @empleado, :status => :created, :location => @empleado }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @empleado.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /empleados/1
  # PUT /empleados/1.xml
  def update
    @empleado = Empleado.find(params[:id])

    respond_to do |format|
      if @empleado.update_attributes(params[:empleado])
        format.html { redirect_to(@empleado, :notice => 'Empleado actualizado correctamente') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @empleado.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /empleados/1
  # DELETE /empleados/1.xml
  def destroy
    @empleado = Empleado.find(params[:id])
    @formacion = Formacion.find(:all, :conditions => ["empleado_id = ?", @empleado])
    if @formacion.empty?
       @empleado.destroy
       flash[:notice] = "Empleado eliminado correctamente"
    else
      flash[:notice] = "Empleado tiene registros asociados, no pudo eliminarse"
    end
    redirect_to :action => "index"
    #    respond_to do |format|
    #      format.html { redirect_to(empleados_url) }
    #      format.xml  { head :ok }
    #    end
  end

  

    ##### FORMACION ACADEMICA ######
  def formacion
    @empleado = Empleado.find(params[:id])
    @formacions = Formacion.find(:all, :conditions => ["empleado_id = ?",  @empleado.id]) if @empleado
  end

  def new_formacion
    @empleado = Empleado.find(params[:id])
    @formacion = Formacion.new
    @formacion.empleado = @empleado if @empleado
    @estudios = Estudio.find(:all, :conditions => ["parent_id IS NOT NULL"])
    @estudios = @estudios.sort { |a, b| a.descripcion_jerarquica <=> b.descripcion_jerarquica  }
    @instituciones_academicas = InstitucionAcademica.find(:all, :order => "descripcion")
  end

  def save_formacion
    @formacion = Formacion.new(params[:formacion])
    @empleado = Empleado.find(params[:empleado]) if params[:empleado]
    @formacion.empleado=@empleado if @empleado
    if @formacion.save
      flash[:notice] = "Estudio guardado correctamente"
      redirect_to :action =>"formacion", :id => @empleado
    else
      flash[:notice] = "No se pudo guardar correctamente"
       @estudios = Estudio.find(:all, :conditions => ["parent_id IS NOT NULL"])
      render :action => "new_formacion"
    end
  end

  def destroy_formacion
    @formacion = Formacion.find(params[:id])
    @empleado = @formacion.empleado
    if @formacion.destroy
       flash[:notice] = "Registro eliminado correctamente"
       redirect_to :action => "formacion", :id => @empleado
    end
  end

  def docs_formacion
    @formacion = Formacion.find(params[:id])
    @emplado = @formacion.empledo
    render :text => "Documentos de formacion del estudio"
  end

 def set_layout
    (action_name == 'show_pdf')? 'pdf' : 'kolaval'
  end

end