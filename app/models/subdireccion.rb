class Subdireccion < ActiveRecord::Base
  belongs_to :municipio
  has_many :tramites
  has_many :salas
end
