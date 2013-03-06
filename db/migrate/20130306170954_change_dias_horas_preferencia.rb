class ChangeDiasHorasPreferencia < ActiveRecord::Migration
  def self.up
    change_column(:comparecencias, :hora_preferencia,  :string, :limit => 120)
    change_column(:comparecencias, :dia_preferencia,  :string, :limit => 120)
  end

  def self.down
    change_column(:comparecencias, :dia_preferencia,  :integer)
    change_column(:comparecencias, :hora_preferencia,  :integer)
  end
end
