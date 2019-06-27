class AddColumnActivoToMotivoConclusions < ActiveRecord::Migration
  def self.up
  	add_column :motivo_conclusions, :activo, :boolean unless MotivoConclusion.column_names.include?("activo")
  end

  def self.down
  	remove_column :motivo_conclusions, :activo
  end
end
