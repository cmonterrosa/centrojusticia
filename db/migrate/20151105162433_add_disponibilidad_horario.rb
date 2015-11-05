class AddDisponibilidadHorario < ActiveRecord::Migration
  def self.up
    add_column :comparecencias, :disponibilidad_horario, :string, :limit => 2
  end

  def self.down
    remove_columns(:comparecencias, :disponibilidad_horario)
  end
end
