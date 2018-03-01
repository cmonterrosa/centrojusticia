class CreateParticipantevisitas < ActiveRecord::Migration
  def self.up
    create_table :participantevisitas do |t|
    	t.integer :visita_id
    	t.integer :user_id
    	t.integer :tipoparticipantevisita_id
      t.timestamps
    end
  end

  def self.down
    drop_table :participantevisitas
  end
end
