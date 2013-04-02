class CreateTipopersonas < ActiveRecord::Migration
  def self.up
    create_table :tipopersonas do |t|
      t.string :descripcion, :limit => 12
    end

    # Create default values
    Tipopersona.create(:descripcion => "FISICA")
    Tipopersona.create(:descripcion => "MORAL")
  end

  def self.down
    drop_table :tipopersonas
  end
end
