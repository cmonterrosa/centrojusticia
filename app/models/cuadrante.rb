class Cuadrante < ActiveRecord::Base
  has_many :participantes
  has_and_belongs_to_many :users
end
