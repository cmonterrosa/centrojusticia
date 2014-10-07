class CreateInstitucionAcademicas < ActiveRecord::Migration
  def self.up
    create_table :institucion_academicas do |t|
      t.string :siglas, :limit => 20
      t.string :descripcion, :limit => 100
     end
  end

  def self.down
    drop_table :institucion_academicas
  end
end
