class SesionesController < ApplicationController
  def list_by_tramite
    @sesiones = Sesion.find(:all, :conditions => ["tramite_id = ?", params[:id]])
  end

  def list_by_user
    @sesiones_mediador = Sesion.find(:all, :conditions => ["mediador_id = ?", current_user.id])
    @sesiones_comediador = Sesion.find(:all, :conditions => ["comediador_id = ?",current_user.id])
  end
end
