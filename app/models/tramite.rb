class Tramite < ActiveRecord::Base
  belongs_to :delegacion
  belongs_to :materia
  belongs_to :user
  belongs_to :estatu
end
