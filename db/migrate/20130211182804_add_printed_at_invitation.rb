class AddPrintedAtInvitation < ActiveRecord::Migration
  def self.up
      add_column :invitacions, :printed_at, :datetime
  end

  def self.down
      remove_columns(:invitacions, :printed_at)
  end
end
