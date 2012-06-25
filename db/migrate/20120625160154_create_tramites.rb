class CreateTramites < ActiveRecord::Migration
  def self.up
    create_table :tramites do |t|
      t.string :anio, :limit => 4
      t.string :folio, :limit => 6
      t.integer :delegacion_id
      t.timestamps
    end

    create_table :tramites_historia, :id => false do |t|
      t.integer :tramite_id
      t.integer :estatus_id
      t.integer :user_id
      t.timestamps
    end


  end

  def self.down
    drop_table :tramites
  end
end
