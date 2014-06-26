class AddFieldNumeroInvitacion < ActiveRecord::Migration
  def self.up
    add_column :invitacions, :numero_invitacion, :integer
    add_column :invitacions, :observaciones, :string, :limit => 180
  end

  def self.down
    remove_columns(:invitacions, :numero_invitacion)
    remove_columns(:invitacions, :observaciones)
  end
end
