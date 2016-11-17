class EtniasController < ApplicationController
  # GET /etnias
  # GET /etnias.xml
  def index
    @etnias = Etnia.all.paginate(:page => params[:page], :per_page => 15)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @etnias }
    end
  end

  # GET /etnias/1
  # GET /etnias/1.xml
  def show
    @etnia = Etnia.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @etnia }
    end
  end

  # GET /etnias/new
  # GET /etnias/new.xml
  def new
    @etnia = Etnia.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @etnia }
    end
  end

  # GET /etnias/1/edit
  def edit
    @etnia = Etnia.find(params[:id])
  end

  # POST /etnias
  # POST /etnias.xml
  def create
    @etnia = Etnia.new(params[:etnia])

    respond_to do |format|
      if @etnia.save
        format.html { redirect_to(@etnia, :notice => 'Etnia creada correctamente.') }
        format.xml  { render :xml => @etnia, :status => :created, :location => @etnia }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @etnia.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /etnias/1
  # PUT /etnias/1.xml
  def update
    @etnia = Etnia.find(params[:id])

    respond_to do |format|
      if @etnia.update_attributes(params[:etnia])
        format.html { redirect_to(@etnia, :notice => 'Etnia actualizada correctamente') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @etnia.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /etnias/1
  # DELETE /etnias/1.xml
  def destroy
    @etnia = Etnia.find(params[:id])
    @etnia.destroy

    respond_to do |format|
      format.html { redirect_to(etnias_url) }
      format.xml  { head :ok }
    end
  end
end
