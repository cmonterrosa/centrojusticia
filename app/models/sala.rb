class Sala < ActiveRecord::Base
  belongs_to :subdireccion
  has_many :orientacions
  has_many :horarios
end
