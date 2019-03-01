class AddColumnMateriaidToMotivoconclusions < ActiveRecord::Migration
  def self.up
  	add_column :motivo_conclusions, :materia_id, :integer unless MotivoConclusion.column_names.include?("materia_id")
  end

  def self.down
  	remove_column :motivo_conclusions, :materia_id
  end
end
