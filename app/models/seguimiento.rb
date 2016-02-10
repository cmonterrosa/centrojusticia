class Seguimiento < ActiveRecord::Base
  belongs_to :convenio
  belongs_to :user
  belongs_to :participante
  belongs_to :manifestacion_seguimiento

  validates_presence_of :convenio_id, :message => ".- Debe de estar vinculado a un convenio"

end