class Municipio < ActiveRecord::Base
  has_many :orientacions
  has_one :subdireccion
end
