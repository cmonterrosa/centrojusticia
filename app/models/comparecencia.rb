class Comparecencia < ActiveRecord::Base
  belongs_to :orientacion
  belongs_to :user
  has_many :participantes
  has_one :expediente
end
