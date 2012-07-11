class Materia < ActiveRecord::Base
  has_many :tramites
  has_and_belongs_to_many :users
end
