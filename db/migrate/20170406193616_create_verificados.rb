class CreateVerificados < ActiveRecord::Migration
  def self.up
    create_table :verificados do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :verificados
  end
end
