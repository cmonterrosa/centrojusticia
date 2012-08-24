class AgendaController < ApplicationController
  require_role "controlagenda", :for => [:management]
 
  def calendario
     @sesiones = Sesion.find(:all, :conditions => ["start_at is not NULL"], :order => "start_at")
     @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
     @title = "Calendario General del Centro Estatal de Justicia Alternativa"
     return render(:partial => 'calendario', :layout => "oficial")
  end

  def management
     @sesiones = Sesion.find(:all, :conditions => ["start_at is not NULL"], :order => "start_at")
     @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
     @title = "Control de agenda"
  end
end
