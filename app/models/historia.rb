class Historia < ActiveRecord::Base
  belongs_to :user
  belongs_to :estatu
  belongs_to :tramite
  belongs_to :justificacion
end
