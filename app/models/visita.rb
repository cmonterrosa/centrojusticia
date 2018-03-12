class Visita < ActiveRecord::Base
	belongs_to :tipovisita
	has_and_belongs_to_many :tramites
	belongs_to :user
	has_many :paricipantevisitas 
	belongs_to :estatus_visita  
end
