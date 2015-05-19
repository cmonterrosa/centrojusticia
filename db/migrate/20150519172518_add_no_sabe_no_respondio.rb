class AddNoSabeNoRespondio < ActiveRecord::Migration
  def self.up
    add_column :participantes, :sabe_procedencia, :string, :limit => 2
    add_column :participantes, :sabe_edad, :string, :limit => 2
    add_column :orientacions, :sabe_procedencia, :string, :limit => 2
  end

  def self.down
    remove_columns(:participantes, :sabe_procedencia)
    remove_columns(:participantes, :sabe_edad)
    remove_columns(:orientacions, :sabe_procedencia)
  end
end
