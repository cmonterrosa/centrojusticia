class CreateInvitacions < ActiveRecord::Migration
  def self.up
    create_table :invitacions do |t|
      t.integer :user_id
      t.integer :sesion_id
      t.boolean :entregada
      t.string  :justificacion
      t.timestamps
      t.datetime :fecha_hora_entrega
    end
    add_index :invitacions, [:sesion_id], :name => "sesion"
  end

  def self.down
    drop_table :invitacions
  end
end
