class Extraordinaria < ActiveRecord::Base
  belongs_to :procedencia
  belongs_to :tramite
  belongs_to :user

  validates_uniqueness_of :tramite_id

  def solicitante
    "#{self.nombre} #{self.paterno} #{self.materno}"
  end


  def especialista
    (self.especialista_id)? User.find(self.especialista_id) : nil
  end


end
