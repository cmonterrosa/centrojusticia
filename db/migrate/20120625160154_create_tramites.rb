class CreateTramites < ActiveRecord::Migration
  def self.up
    create_table :tramites do |t|
      t.string :anio, :limit => 4
      t.string :folio, :limit => 6
      t.integer :subdireccion_id
      #-- relacion con otras tablas ---
      t.integer :estatu_id
      t.integer :materia_id
      t.integer :user_id
      # --- estampas de tiempo
      t.datetime :fecha_fin
      t.timestamps
    end

    add_index :tramites, [:anio, :folio], :name => "busqueda"
#    add_index :tramites, [:estatu_id], :name => "estatus"
   end

  def self.down
    drop_table :tramites
  end
end
