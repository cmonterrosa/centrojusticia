class CreateCertificacions < ActiveRecord::Migration
  def self.up
    create_table :certificacions do |t|
      t.integer :empleado_id
      t.string :tipo, :limit => 20
      t.string :categoria, :limit => 25
      t.string :encabezado
      t.string :mgdo_presidente, :limit => 60
      t.string :director_ceja, :limit => 60
      t.date :fecha_emision
      t.string :folio, :limit => 25
      t.string :observaciones, :limit => 155
      t.timestamps
    end

     add_index :certificacions, [:empleado_id], :name => "certificaciones_empleado"

  end

  def self.down
    drop_table :certificacions
  end
end
