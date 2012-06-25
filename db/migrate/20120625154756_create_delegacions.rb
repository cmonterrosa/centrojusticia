class CreateDelegacions < ActiveRecord::Migration
  def self.up
    create_table :delegacions do |t|
      t.string :descripcion, :limit => 100
      t.string :titular, :limit => 120
      t.string :direccion, :limit => 100
      #---- relacion con otras tablas ---
      t.string :municipio_id, :integer
    end
  end

  def self.down
    drop_table :delegacions
  end
end
