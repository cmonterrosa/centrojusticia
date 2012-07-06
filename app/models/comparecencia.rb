class Comparecencia < ActiveRecord::Base
  belongs_to :tramite
  belongs_to :user
  has_many :participantes
  has_one :expediente
end
