class CreateNoprocedentes < ActiveRecord::Migration
  def self.up
    create_table :noprocedentes do |t|
      t.string :clave, :limit => 8
      t.string :descripcion, :limit => 120
    end

    ## Creamos la columna en la tabla tramites
    add_column :tramites, :noprocedente_id, :integer

    t = Noprocedente.create(:clave => "nocomp", :descripcion => "No es de competencia ")
    t = Noprocedente.create(:clave => "norequ", :descripcion => "No cumple los requisitos mínimos de ley")
    t = Noprocedente.create(:clave => "otra", :descripcion => "Otra")
  end

  def self.down
    drop_table :noprocedentes
    remove_columns(:tramites, :noprocedente_id)
  end
end
