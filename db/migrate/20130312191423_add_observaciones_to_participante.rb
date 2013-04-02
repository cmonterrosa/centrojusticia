class AddObservacionesToParticipante < ActiveRecord::Migration
   def self.up
      remove_columns(:comparecencias, :observaciones)
      add_column :participantes, :observaciones, :string
      add_index :participantes, [:comparecencia_id], :name => "comparecencia"
   end

  def self.down
      remove_columns(:participantes, :observaciones)
      add_column :comparecencias, :observaciones, :string
      remove_index :participantes, :name => :comparecencia
  end
end
