class CreateCierreanios < ActiveRecord::Migration
  def self.up
    create_table :cierreanios do |t|    	
      t.date :fecha
      t.integer :user_id
      t.string :cargo
      t.string :tipo_razon
      t.string :director
      t.string :presidente
      t.integer :subdireccion_id
      t.string :lugar
      t.string :observaciones    	
      t.timestamps
    end
  end
  

  def self.down
    drop_table :cierreanios
  end
end
