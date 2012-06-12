class Expediente < ActiveRecord::Base
  belongs_to :materia
  belongs_to :user
  belongs_to :comparecencia
end
