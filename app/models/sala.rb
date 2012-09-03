class Sala < ActiveRecord::Base
  has_many :orientacions
  has_many :horarios
end
