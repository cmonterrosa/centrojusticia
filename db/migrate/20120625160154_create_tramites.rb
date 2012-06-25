class CreateTramites < ActiveRecord::Migration
  def self.up
    create_table :tramites do |t|
      t.string :anio, :limit => 4
      t.string :folio, :limit => 6
      t.integer :delegacion_id
      #-- relacion con otras tablas ---
      t.integer :estatus_id
      t.integer :materia_id
      t.integer :user_id
      t.timestamps
    end

    add_index :tramites, [:anio, :folio], :name => "busqueda"
   end

  def self.down
    drop_table :tramites
  end
end
