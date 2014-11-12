class AddNumeroInvitacionSesiones < ActiveRecord::Migration
  def self.up
    add_column :sesions, :num_invitacion, :integer
  end

  def self.down
    remove_columns(:sesions, :num_invitacion)
  end
end
