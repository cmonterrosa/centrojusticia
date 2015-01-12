class AddFieldsToCertificacion < ActiveRecord::Migration
  def self.up
    add_column :certificacions, :numero_oficio, :string, :limit => 25
    add_column :certificacions, :secretaria_consejo, :string, :limit => 60
  end

  def self.down
    remove_columns(:certificacions, :numero_oficio)
    remove_columns(:certificacions, :secretaria_consejo)
  end
end
