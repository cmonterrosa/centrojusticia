class InstitucionAcademicasController < ApplicationController
  # GET /institucion_academicas
  # GET /institucion_academicas.xml
  def index
    @institucion_academicas = InstitucionAcademica.find(:all, :order => "descripcion").paginate(:page => params[:page], :per_page => 25)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @institucion_academicas }
    end
  end

  # GET /institucion_academicas/1
  # GET /institucion_academicas/1.xml
  def show
    @institucion_academica = InstitucionAcademica.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @institucion_academica }
    end
  end

  # GET /institucion_academicas/new
  # GET /institucion_academicas/new.xml
  def new
    @institucion_academica = InstitucionAcademica.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @institucion_academica }
    end
  end

  # GET /institucion_academicas/1/edit
  def edit
    @institucion_academica = InstitucionAcademica.find(params[:id])
  end

  # POST /institucion_academicas
  # POST /institucion_academicas.xml
  def create
    @institucion_academica = InstitucionAcademica.new(params[:institucion_academica])

    respond_to do |format|
      if @institucion_academica.save
        format.html { redirect_to(@institucion_academica, :notice => 'InstitucionAcademica was successfully created.') }
        format.xml  { render :xml => @institucion_academica, :status => :created, :location => @institucion_academica }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @institucion_academica.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /institucion_academicas/1
  # PUT /institucion_academicas/1.xml
  def update
    @institucion_academica = InstitucionAcademica.find(params[:id])

    respond_to do |format|
      if @institucion_academica.update_attributes(params[:institucion_academica])
        format.html { redirect_to(@institucion_academica, :notice => 'InstitucionAcademica was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @institucion_academica.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /institucion_academicas/1
  # DELETE /institucion_academicas/1.xml
  def destroy
    @institucion_academica = InstitucionAcademica.find(params[:id])
    @institucion_academica.destroy

    respond_to do |format|
      format.html { redirect_to(institucion_academicas_url) }
      format.xml  { head :ok }
    end
  end
end
