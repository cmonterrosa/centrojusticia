class Estatu < ActiveRecord::Base
  has_many :orientacions
  has_many :tramites
  has_and_belongs_to_many :roles

  validates_uniqueness_of :clave, :message => "ya se encuentra registrado"

end
