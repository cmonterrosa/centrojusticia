class AgendaController < ApplicationController
 
  def calendario
     @sesiones = Sesion.find(:all, :order => "start_at")
     @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today
     @title = "Calendario General del Centro Estatal de Justicia Alternativa"
     return render(:partial => 'calendario', :layout => "oficial")
  end

end
