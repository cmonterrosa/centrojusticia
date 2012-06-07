class Comparecencia < ActiveRecord::Base
  belongs_to :orientacion
  belongs_to :user
  has_and_belongs_to_many :participantes
end
