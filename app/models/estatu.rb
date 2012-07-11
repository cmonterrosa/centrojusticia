class Estatu < ActiveRecord::Base
  has_many :orientacions
  has_many :tramites
end
