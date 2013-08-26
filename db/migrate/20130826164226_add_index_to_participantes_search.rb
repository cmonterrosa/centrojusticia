class AddIndexToParticipantesSearch < ActiveRecord::Migration
  def self.up
     add_index :participantes, [:comparecencia_id, :perfil], :name => "busqueda_perfil"
  end

  def self.down
     remove_index(:participantes, :busqueda_perfil)
  end
end
