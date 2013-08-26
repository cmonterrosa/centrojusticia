class AddParticipanteToInvitacion < ActiveRecord::Migration
  def self.up
     add_column :invitacions, :participante_id,  :integer
  end

  def self.down
    remove_columns(:invitacions, :participante_id)
  end
end
