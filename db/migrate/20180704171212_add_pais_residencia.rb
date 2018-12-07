class AddPaisResidencia < ActiveRecord::Migration
  def self.up
  	add_column :participantes, :pais_residencia_id, :integer unless Participante.column_names.include?("pais_residencia_id")
	add_column :participantes, :municipio_residencia_id, :integer unless Participante.column_names.include?("municipio_residencia_id")
  end

  def self.down
  	remove_column :participantes, :pais_residencia_id, :integer
  	remove_column :participantes, :municipio_residencia_id, :integer
  end
end
