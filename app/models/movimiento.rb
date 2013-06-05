class Movimiento < ActiveRecord::Base
  belongs_to :user
  belongs_to :situacion
end
