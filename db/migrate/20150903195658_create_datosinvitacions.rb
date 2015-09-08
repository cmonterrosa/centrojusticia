class CreateDatosinvitacions < ActiveRecord::Migration
  def self.up
    create_table :datosinvitacions do |t|
        t.column :fecha_actual, :date
        t.column :especialista, :string, :limit => 60
        t.column :subdireccion, :string, :limit => 60
        t.column :solicitante, :string, :limit => 70
        t.column :fecha_solicitud, :string, :limit => 50
        t.column :fechahora_sesion, :string, :limit => 50
        t.column :materia, :string, :limit => 60
        t.column :lugar, :string, :limit => 80
        t.column :genero_solicitante, :string, :limit => 20
        t.column :subdirector, :string, :limit => 70
        t.column :cargo, :string, :limit => 50
        t.column :sesion_id, :integer
        t.column :user_id, :integer
        t.timestamps
    end
    add_index :datosinvitacions, [:sesion_id], :name => "datosinvitacions_sesion"
end

  def self.down
    drop_table :datosinvitacions
  end
end


