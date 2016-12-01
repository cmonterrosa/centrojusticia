class SituacionsController < ApplicationController
  require_role [:admin]
  # GET /situacions
  # GET /situacions.xml
  def index
    @situacions = Situacion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @situacions }
    end
  end

  # GET /situacions/1
  # GET /situacions/1.xml
  def show
    @situacion = Situacion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @situacion }
    end
  end

  # GET /situacions/new
  # GET /situacions/new.xml
  def new
    @situacion = Situacion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @situacion }
    end
  end

  # GET /situacions/1/edit
  def edit
    @situacion = Situacion.find(params[:id])
  end

  # POST /situacions
  # POST /situacions.xml
  def create
    @situacion = Situacion.new(params[:situacion])

    respond_to do |format|
      if @situacion.save
        format.html { redirect_to(@situacion, :notice => 'Registro creado correctamente') }
        format.xml  { render :xml => @situacion, :status => :created, :location => @situacion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @situacion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /situacions/1
  # PUT /situacions/1.xml
  def update
    @situacion = Situacion.find(params[:id])

    respond_to do |format|
      if @situacion.update_attributes(params[:situacion])
        format.html { redirect_to(@situacion, :notice => 'Registro actualizado correctamente.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @situacion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /situacions/1
  # DELETE /situacions/1.xml
  def destroy
    @situacion = Situacion.find(params[:id])
    @situacion.destroy

    respond_to do |format|
      format.html { redirect_to(situacions_url) }
      format.xml  { head :ok }
    end
  end
end
