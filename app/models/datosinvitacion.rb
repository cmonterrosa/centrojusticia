class Datosinvitacion < ActiveRecord::Base
  belongs_to :sesion
  belongs_to :user
  has_many :invitacions
end




