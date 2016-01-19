class ModifySizeofResultadoSesion < ActiveRecord::Migration
  def self.up
    change_column(:sesions, :resultado, :text, :limit => 500)
  end

  def self.down
  end
end
