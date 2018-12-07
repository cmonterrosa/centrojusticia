class CreateVerificados < ActiveRecord::Migration
  def self.up
	if !table_exists?("verificados")
	    create_table :verificados do |t|

	      t.timestamps
	    end
	end
  end

  def self.down
    drop_table :verificados
  end
end
