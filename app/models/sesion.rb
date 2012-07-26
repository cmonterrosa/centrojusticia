class Sesion < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :estatus_sesion

  def mediador
    return (User.find(self.mediador_id)) if self.mediador_id
  end
  
  def comediador
    return (User.find(self.comediador_id)) if self.comediador_id
  end



end
