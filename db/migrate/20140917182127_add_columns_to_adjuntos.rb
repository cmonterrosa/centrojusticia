class AddColumnsToAdjuntos < ActiveRecord::Migration
 def self.up
    add_column :adjuntos, :empleado_id, :integer
    add_column :adjuntos,  :formacion_id, :integer
    add_index :adjuntos, [:formacion_id], :name => "formacion"
     add_index :adjuntos, [:empleado_id], :name => "empleado"
  end

  def self.down
    remove_columns(:adjuntos, :empleado_id)
    remove_columns(:adjuntos, :formacion_id)
    remove_index(:adjuntos, :formacion)
    remove_index(:adjuntos, :empleado)
  end
end
