class Participantevisita < ActiveRecord::Base
	belongs_to :user
	belongs_to :visita
end
