class AddApoderadoToParticipante < ActiveRecord::Migration
  def self.up
    add_column :participantes, :apoderado_legal, :string, :limit => 100
  end

  def self.down
    remove_columns(:participantes, :apoderado_legal)
  end
end
