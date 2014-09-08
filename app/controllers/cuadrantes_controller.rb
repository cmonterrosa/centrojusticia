#!/bin/env ruby
# encoding: utf-8
class CuadrantesController < ApplicationController
  # GET /cuadrantes
  # GET /cuadrantes.xml
  layout 'kolaval'
  require_role [:jefeatencionpublico, :direccion, :subdireccion]

  def index
    @cuadrantes = Cuadrante.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cuadrantes }
    end
  end

  # GET /cuadrantes/1
  # GET /cuadrantes/1.xml
  def show
    @cuadrante = Cuadrante.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cuadrante }
    end
  end

  # GET /cuadrantes/new
  # GET /cuadrantes/new.xml
  def new
    @cuadrante = Cuadrante.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cuadrante }
    end
  end

  # GET /cuadrantes/1/edit
  def edit
    @cuadrante = Cuadrante.find(params[:id])
  end

  # POST /cuadrantes
  # POST /cuadrantes.xml
  def create
    @cuadrante = Cuadrante.new(params[:cuadrante])

    respond_to do |format|
      if @cuadrante.save
        format.html { redirect_to(@cuadrante, :notice => 'Registro guardado correctamente') }
        format.xml  { render :xml => @cuadrante, :status => :created, :location => @cuadrante }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cuadrante.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cuadrantes/1
  # PUT /cuadrantes/1.xml
  def update
    @cuadrante = Cuadrante.find(params[:id])

    respond_to do |format|
      if @cuadrante.update_attributes(params[:cuadrante])
        format.html { redirect_to(@cuadrante, :notice => 'Registro actualizado correctamente') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cuadrante.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cuadrantes/1
  # DELETE /cuadrantes/1.xml
  def destroy
    @cuadrante = Cuadrante.find(params[:id])
    @cuadrante.destroy

    respond_to do |format|
      format.html { redirect_to(cuadrantes_url) }
      format.xml  { head :ok }
    end
  end

  def invitadores_by_cuadrante
    @cuadrante = Cuadrante.find(params[:id])
    @invitadores_cuadrante = @cuadrante.users
    @invitadores = []
    Role.find(:first, :conditions => ["name = ?", 'invitadores']).users.each{|user|
        @invitadores << user unless @cuadrante.users.include?(user)
      }
    @todos_invitadores = @invitadores.sort{|p1,p2|p1.nombre_completo <=> p2.nombre_completo}
  end

  def add_invitador
    @cuadrante = Cuadrante.find(params[:cuadrante])
    if params[:user][:user_id] =~ /\d/
        @cuadrante.users << User.find(params[:user][:user_id])
        flash[:notice] = (@cuadrante.save) ? "Invitador agregado correctamente" : "El usuario no fue agregado, verifique"
        redirect_to :action => "invitadores_by_cuadrante", :id => @cuadrante
    else
      flash[:notice] = "No se registró ningún invitador, verifique"
      redirect_to :action => "invitadores_by_cuadrante", :id => @cuadrante
    end

  end

   def quit_invitador
    @cuadrante = Cuadrante.find(params[:cuadrante])
    @invitador = User.find(params[:id])
    @cuadrante.users.delete(@invitador)
    flash[:notice] = (@cuadrante.save) ? "Invitador eliminado correctamente" : "El usuario no fue eliminado, verifique"
    redirect_to :action => "invitadores_by_cuadrante", :id => @cuadrante
  end
end
