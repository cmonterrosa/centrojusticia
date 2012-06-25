class Subdireccion < ActiveRecord::Base
  belongs_to :municipio
  has_many :tramites
end
