class AddColumnsParticipantes < ActiveRecord::Migration
  def self.up
  	if !table_exists?("fuente_ingresos")
	  create_table "fuente_ingresos" do |t|
	    t.string :clave
	    t.string :descripcion, :limit => 40
	    t.boolean :activo
	  end
	end

	if !table_exists?("tipoviviendas")
	  create_table "tipoviviendas" do |t|
	    t.string :clave
	    t.string :descripcion, :limit => 100
	    t.boolean :activo
	  end
	end

	if !table_exists?("servicio_medicos")
	  create_table "servicio_medicos" do |t|
	    t.string :clave
	    t.string :descripcion, :limit => 100
	    t.boolean :activo
	  end
	end

	if !table_exists?("ocupacions")
	  create_table "ocupacions" do |t|
	    t.string :clave
	    t.string :descripcion, :limit => 100
	    t.boolean :activo
	  end
	end

	if !table_exists?("alfabetismos")  
	  create_table "alfabetismos" do |t|
	    t.string :clave
	    t.string :descripcion, :limit => 40
	    t.boolean :activo
	  end
	end

	if !table_exists?("estado_psicofisicos")
	  create_table "estado_psicofisicos" do |t|
	    t.string :clave
	    t.string :descripcion, :limit => 40
	    t.boolean :activo
	  end
	end

	if !table_exists?("tipoasesors")
	  create_table "tipoasesors" do |t|
	    t.string :clave
	    t.string :descripcion, :limit => 40
	    t.boolean :activo
	  end
	end

	if !table_exists?("calidad_migratorias")
	  create_table "calidad_migratorias" do |t|
	    t.string :clave
	    t.string :descripcion, :limit => 40
	    t.boolean :activo
	  end
	end

	if !table_exists?("estatus_migratorios")
	  create_table "estatus_migratorios" do |t|
	    t.string :clave
	    t.string :descripcion, :limit => 40
	    t.boolean :activo
	  end
	end   

	  add_column :participantes, :codigo_postal, :string, :limit => 5 unless Participante.column_names.include?("codigo_postal")
	  add_column :participantes, :fuente_ingreso_id, :integer unless Participante.column_names.include?("fuente_ingreso_id")
	  add_column :participantes, :tipovivienda_id, :integer unless Participante.column_names.include?("tipovivienda_id")
	  add_column :participantes, :servicio_medico_id, :integer unless Participante.column_names.include?("servicio_medico_id")
	  add_column :participantes, :ocupacion_id, :integer unless Participante.column_names.include?("ocupacion_id")
	  add_column :participantes, :ingreso_mensual, :integer unless Participante.column_names.include?("ingreso_mensual")
	  add_column :participantes, :alfabetismo_id, :integer unless Participante.column_names.include?("alfabetismo_id")
	  add_column :participantes, :nivel_academico_id, :integer unless Participante.column_names.include?("nivel_academico_id")
	  add_column :participantes, :limitacion_fisica, :string, :limit => 100 unless Participante.column_names.include?("limitacion_fisica")
	  add_column :participantes, :enfermedad, :string, :limit => 100 unless Participante.column_names.include?("enfermedad")
	  add_column :participantes, :enfermedad_mental, :string, :limit => 100 unless Participante.column_names.include?("enfermedad_mental")
	  add_column :participantes, :habla_espanol, :boolean unless Participante.column_names.include?("habla_espanol")
	  add_column :participantes, :lengua_extranjera, :boolean unless Participante.column_names.include?("lengua_extranjera")
	  add_column :participantes, :requirio_traductor, :boolean unless Participante.column_names.include?("requirio_traductor")
	  add_column :participantes, :embarazada, :boolean unless Participante.column_names.include?("embarazada")
	  add_column :participantes, :estado_psicofisico_id, :integer unless Participante.column_names.include?("estado_psicofisico_id")
	  add_column :participantes, :tipoasesor_id, :integer unless Participante.column_names.include?("tipoasesor_id")
	  add_column :participantes, :es_migrante, :boolean unless Participante.column_names.include?("es_migrante")
	  add_column :participantes, :calidad_migratoria_id, :integer unless Participante.column_names.include?("calidad_migratoria_id")
	  add_column :participantes, :estatus_migratorio_id, :integer unless Participante.column_names.include?("estatus_migratorio_id")
  end


  def self.down
	  remove_column :participantes, :codigo_postal, :integer
	  remove_column :participantes, :fuente_ingreso_id, :integer
	  remove_column :participantes, :tipovivienda_id, :integer
	  remove_column :participantes, :servicio_medico_id, :integer
	  remove_column :participantes, :ocupacion_id, :integer
	  remove_column :participantes, :ingreso_mensual, :integer
	  remove_column :participantes, :alfabetismo_id, :integer
	  remove_column :participantes, :nivel_academico_id, :integer
	  remove_column :participantes, :limitacion_fisica, :string
	  remove_column :participantes, :enfermedad, :string
	  remove_column :participantes, :enfermedad_mental, :string
	  remove_column :participantes, :habla_espanol, :boolean
	  remove_column :participantes, :lengua_extranjera, :boolean
	  remove_column :participantes, :requirio_traductor, :boolean
	  remove_column :participantes, :embarazada, :boolean
	  remove_column :participantes, :estado_psicofisico_id, :integer
	  remove_column :participantes, :tipoasesor_id, :integer
	  remove_column :participantes, :es_migrante, :boolean
	  remove_column :participantes, :calidad_migratoria_id, :integer
	  remove_colmun :participantes, :estatus_migratorio_id, :integer

	  drop_table :fuente_ingresos
	  drop_table :tipoviviendas
	  drop_table :servicio_medicos
	  drop_table :ocupacions
	  drop_table :alfabetismos
	  drop_table :estado_psicofisicos
	  drop_table :tipoasesors
	  drop_table :calidad_migratorias
	  drop_table :estatus_migratorios
  end
end
