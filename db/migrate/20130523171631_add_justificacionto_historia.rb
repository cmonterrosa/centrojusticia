class AddJustificaciontoHistoria < ActiveRecord::Migration
  def self.up
    add_column :historias, :justificacion_id, :integer
    add_column :historias, :especialista_id, :integer
  end

  def self.down
    remove_columns(:historias, :justificacion_id)
    remove_columns(:historias, :especialista_id)
  end  
end
