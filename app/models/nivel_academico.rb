class NivelAcademico < ActiveRecord::Base
  has_many :estudios
  has_many :participantes
end
