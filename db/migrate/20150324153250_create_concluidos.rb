class CreateConcluidos < ActiveRecord::Migration
  def self.up
    create_table :concluidos do |t|
        t.column :user_id, :integer
        t.column :tramite_id, :integer
        t.column  :motivo_conclusion_id, :integer
        t.column  :observaciones_conclusion, :string
        t.timestamps
    end
    add_index :concluidos, [:tramite_id], :name => "concluidos_tramite"
    add_index :concluidos, [:user_id], :name => "concluidos_user"

    ## Creamos estatus de concluido ###
    concluido = Estatu.create(:descripcion => "Trámite concluido", :clave => "tram-conc", :is_default => false, :is_finish => true)
  end

  def self.down
    drop_table :concluidos
  end
end
