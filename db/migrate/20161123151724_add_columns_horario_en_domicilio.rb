class AddColumnsHorarioEnDomicilio < ActiveRecord::Migration
  def self.up
    add_column :participantes, :horario_disponible_domicilio_particular, :string, :limit => 160
    add_column :participantes, :horario_disponible_domicilio_laboral, :string, :limit => 160
  end

  def self.down
    remove_column :participantes, :horario_disponible_domicilio_particular
    remove_column :participantes, :horario_disponible_domicilio_laboral
  end
end
