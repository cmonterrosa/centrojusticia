class CreateVisitas < ActiveRecord::Migration
  def self.up
    if !table_exists?("visitas")
      create_table :visitas do |t|    	
      	t.datetime :fechahora_inicio
      	t.datetime :fechahora_fin
      	t.integer :user_id
      	t.integer :tipovisita_id
      	t.datetime :periodo_inicio
      	t.datetime :periodo_fin
      	t.integer :estatus_visita_id
      	t.string :observaciones    	
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :visitas
  end
end
