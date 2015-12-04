class CreateSeguimientos < ActiveRecord::Migration
  def self.up
    create_table :seguimientos do |t|
      t.column :convenio_id, :integer
      t.column :user_id, :integer
      t.column :participante_id, :integer
      t.column :fechahora, :datetime
      t.column :numero_marcado, :string, :limit =>20
      t.column :descripcion, :string
      t.column :manifestacion_seguimiento_id, :integer
      t.timestamps
    end

  add_index :seguimientos, [:convenio_id], :name => "seguimientos_convenio"
  add_index :seguimientos, [:participante_id], :name => "seguimientos_participante"
  add_index :seguimientos, [:user_id], :name => "seguimientos_user"
end

  def self.down
    drop_table :seguimientos
  end
end

