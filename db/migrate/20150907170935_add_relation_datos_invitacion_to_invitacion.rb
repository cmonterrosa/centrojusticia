class AddRelationDatosInvitacionToInvitacion < ActiveRecord::Migration
  def self.up
    add_column :invitacions, :datosinvitacion_id, :integer
    add_index :invitacions, [:datosinvitacion_id], :name => "invitacion_datosinvitacion"
  end

  def self.down
    remove_column :invitacions, :datosinvitacion_id
  end
end
