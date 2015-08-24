class SubdireccionsController < ApplicationController
  require_role [:admin]
  
  # GET /subdireccions
  # GET /subdireccions.xml
  def index
    @subdireccions = Subdireccion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subdireccions }
    end
  end

  # GET /subdireccions/1
  # GET /subdireccions/1.xml
  def show
    @subdireccion = Subdireccion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subdireccion }
    end
  end

  # GET /subdireccions/new
  # GET /subdireccions/new.xml
  def new
    @subdireccion = Subdireccion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subdireccion }
    end
  end

  # GET /subdireccions/1/edit
  def edit
    @subdireccion = Subdireccion.find(params[:id])
  end

  # POST /subdireccions
  # POST /subdireccions.xml
  def create
    @subdireccion = Subdireccion.new(params[:subdireccion])

    respond_to do |format|
      if @subdireccion.save
        format.html { redirect_to(@subdireccion, :notice => 'Subdireccion was successfully created.') }
        format.xml  { render :xml => @subdireccion, :status => :created, :location => @subdireccion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subdireccion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /subdireccions/1
  # PUT /subdireccions/1.xml
  def update
    @subdireccion = Subdireccion.find(params[:id])

    respond_to do |format|
      if @subdireccion.update_attributes(params[:subdireccion])
        format.html { redirect_to(@subdireccion, :notice => 'Subdireccion was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @subdireccion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /subdireccions/1
  # DELETE /subdireccions/1.xml
  def destroy
    @subdireccion = Subdireccion.find(params[:id])
    @users = User.count(:id, :conditions => ["subdireccion_id = ?", @subdireccion]) if @subdireccion
    if @subdireccion && @users < 1
      @subdireccion.destroy
    end

    respond_to do |format|
      format.html { redirect_to(subdireccions_url) }
      format.xml  { head :ok }
    end
  end
end
