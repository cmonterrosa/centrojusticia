class Comparecencia < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :user
  has_many :participantes
  has_one :expediente

  #validates_uniqueness_of :tramite_id

  def before_save
#    self.asunto.upcase! if self.asunto
#    self.caracter.upcase! if self.caracter
#    self.datos.upcase! if self.datos
#    self.dia_preferencia.upcase if self.dia_preferencia
#    self.hora_preferencia.upcase if self.hora_preferencia
#    self.procedencia.upcase! if self.procedencia
  end

  def solicitante
    return (Participante.find(:first, :conditions => ["comparecencia_id = ? AND perfil = 'SOLICITANTE'", self.id]))
  end

  def solicitantes
    @solicitantes = Participante.find(:all, :conditions => ["comparecencia_id = ? AND perfil = 'SOLICITANTE'", self.id])
    (@solicitantes) ? @solicitantes.map{|x|x.nombre_completo}.join(", ") : nil
  end

  def involucrados
    @solicitantes = Participante.find(:all, :conditions => ["comparecencia_id = ? AND perfil = 'INVOLUCRADO'", self.id])
    (@solicitantes) ? @solicitantes.map{|x|x.nombre_completo}.join(", ") : nil
  end


end
