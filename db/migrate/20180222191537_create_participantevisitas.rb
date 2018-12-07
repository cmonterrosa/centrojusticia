class CreateParticipantevisitas < ActiveRecord::Migration
  def self.up
    if !table_exists?("participantevisitas")
      create_table :participantevisitas do |t|
      	t.integer :visita_id
      	t.integer :user_id
      	t.integer :tipoparticipantevisita_id
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :participantevisitas
  end
end
