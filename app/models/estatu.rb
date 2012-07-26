class Estatu < ActiveRecord::Base
  has_many :orientacions
  has_many :tramites
  has_and_belongs_to_many :roles
end
