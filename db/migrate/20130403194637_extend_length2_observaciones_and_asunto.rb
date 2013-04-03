class ExtendLength2ObservacionesAndAsunto < ActiveRecord::Migration
    def self.up
    change_column(:comparecencias, :asunto,  :text)
    change_column(:participantes, :observaciones, :text)
  end

  def self.down
    change_column(:comparecencias, :asunto,  :string)
    change_column(:participantes, :observaciones, :string)
  end
end
