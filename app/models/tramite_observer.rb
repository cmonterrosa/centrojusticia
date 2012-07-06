class TramiteObserver < ActiveRecord::Observer
  def after_create(tramite)
     NotificationsMailer.deliver_tramite_created(tramite, tramite.user)
  end

  def after_save(tramite)
     NotificationsMailer.deliver_tramite_updated(tramite, tramite.user)
  end
end