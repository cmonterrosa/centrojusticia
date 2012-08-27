class AgendaController < ApplicationController
  require_role "controlagenda", :for => [:management]
 
  def calendario
     @sesiones = Sesion.find(:all, :conditions => ["start_at is not NULL"], :order => "start_at")
     @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
     @title = "Calendario General del Centro Estatal de Justicia Alternativa"
     return render(:partial => 'calendario', :layout => "oficial")
  end

  def management
     @sesion = Sesion.new
     @sesiones = Sesion.find(:all, :conditions => ["start_at is not NULL"], :order => "start_at")
     @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
     @title = "Control de agenda"
  end

  def search_sesiones
    a=10
  end

end
