class CreateEtnias < ActiveRecord::Migration
  def self.up
    create_table :etnias do |t|
      t.string :descripcion, :limit => 100
      t.timestamps
    end
    add_column :participantes, :pertenece_grupo_etnico, :boolean
    add_column :participantes, :etnia_id, :integer
    add_index [:participantes], [:etnia_id], :name => "participantes_etnias"

    #### CREAMOS CATALOGO DE ETNIAS ###
    Etnia.create(:descripcion => "TZELTAL") unless Etnia.exists?(:descripcion => "TZELTAL")
    Etnia.create(:descripcion => "TZOTZIL") unless Etnia.exists?(:descripcion => "TZOTZIL")
    Etnia.create(:descripcion => "CHOL") unless Etnia.exists?(:descripcion => "CHOL")
    Etnia.create(:descripcion => "ZOQUE") unless Etnia.exists?(:descripcion => "ZOQUE")
    Etnia.create(:descripcion => "MOCHÓ") unless Etnia.exists?(:descripcion => "MOCHÓ")
    Etnia.create(:descripcion => "MAME") unless Etnia.exists?(:descripcion => "MAMES")
    Etnia.create(:descripcion => "TOJOLABAL") unless Etnia.exists?(:descripcion => "TOJOLABAL")
    Etnia.create(:descripcion => "LACANDON") unless Etnia.exists?(:descripcion => "LACANDON")
    Etnia.create(:descripcion => "OTRO") unless Etnia.exists?(:descripcion => "OTRO")
    Etnia.create(:descripcion => "SE DESCONOCE") unless Etnia.exists?(:descripcion => "SE DESCONOCE")
end

  def self.down
    drop_table :etnias
    remove_column :participantes, :etnia_id
    remove_column :participantes, :pertenece_grupo_etnico
  end
end
