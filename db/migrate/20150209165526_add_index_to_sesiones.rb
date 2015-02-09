class AddIndexToSesiones < ActiveRecord::Migration
  def self.up
    remove_index(:sesions, :sesion_busqueda_diaria)
    remove_index(:sesions, :sesion_busqueda_completa)
    add_index :sesions, [:fecha, :hora, :minutos, :sala_id], :name => "sesion_busqueda_completa"
    add_index :sesions, [:fecha, :sala_id, :horario_id, :activa], :name => "sesion_busqueda_activas"
  end

  def self.down
    remove_index(:sesions, :sesion_busqueda_completa)
     #remove_index(:sesions, :sesion_busqueda_activas)
    add_index :sesions, [:hora, :minutos, :sala_id], :name => "sesion_busqueda_diaria"
  end
end
