class Extraordinaria < ActiveRecord::Base
  belongs_to :procedencia
  belongs_to :tramite
  belongs_to :user

  def solicitante
    "#{self.nombre} #{self.paterno} #{self.materno}"
  end


  def especialista
    if self.especialista_id
       return User.find(self.especialista_id)
    else
      return nil
    end
  end


end
