class CreateConvenios < ActiveRecord::Migration
  def self.up
    create_table :convenios do |t|
      t.column :folio, :string, :limit => 11
      t.column :tramite_id, :integer
      t.column :fechahora, :datetime
      t.column :especialista_id, :integer
      t.column :descripcion, :string
      t.column :observaciones, :string
      t.column :cantidad_monetaria, :string
      t.column :plazo, :string
      t.column :tipo_acuerdo, :string
      t.column :validado, :boolean
      t.column :fechahora_validacion, :datetime
      t.timestamps
    end

    add_column :adjuntos, :md5, :string, :limit => 32
    add_column :adjuntos, :convenio_id, :integer
    add_column :adjuntos, :user_id, :integer
    add_column :adjuntos, :descripcion, :string, :limit => 100
    add_index :adjuntos, [:convenio_id], :name => "adjuntos_convenios"
    add_index :convenios, [:folio], :name => "convenios_folio"
    add_index :convenios, [:tramite_id], :name => "convenios_tramite"
    add_index :convenios, [:especialista_id], :name => "convenios_especialista"
    add_index :convenios, [:especialista_id, :validado], :name => "convenios_especialista_validado"
    add_index :convenios, [:validado], :name => "convenios_validado"
  end

  def self.down
    drop_table :convenios
  end
end
