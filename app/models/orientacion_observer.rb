class OrientacionObserver < ActiveRecord::Observer
  def after_create(orientacion)
    NotificationsMailer.deliver_orientacion_created(orientacion, orientacion.user)
  end

  def after_save(orientacion)
    NotificationsMailer.deliver_orientacion_updated(orientacion, orientacion.user)
  end
end