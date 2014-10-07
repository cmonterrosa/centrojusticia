class Formacion < ActiveRecord::Base
  belongs_to :empleado
  belongs_to :estudio
  belongs_to :institucion_academica
  belongs_to :user
  has_many :adjuntos
end
