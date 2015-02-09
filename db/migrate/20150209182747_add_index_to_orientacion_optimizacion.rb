class AddIndexToOrientacionOptimizacion < ActiveRecord::Migration
  def self.up

#     remove_index(:orientacions, :orientacion_tramite)
#    remove_index(:orientacions, :orientacion_especialista)

    add_index :orientacions, [:tramite_id], :name => "orientacion_tramite"
    add_index :orientacions, [:tramite_id, :especialista_id, :fechahora], :name => "orientacion_especialista"
  end

  def self.down
    remove_index(:orientacions, :orientacion_tramite)
    remove_index(:orientacions, :orientacion_especialista)
  end
end
