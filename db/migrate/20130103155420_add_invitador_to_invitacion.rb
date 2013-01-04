class AddInvitadorToInvitacion < ActiveRecord::Migration
  def self.up
      add_column :invitacions, :invitador_id, :integer
  end

  def self.down
      remove_columns(:invitacions, :invitador_id)
  end
end
