class Situacion < ActiveRecord::Base
  has_many :users
  has_many :movimientos
end
