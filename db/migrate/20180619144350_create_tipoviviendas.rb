class CreateTipoviviendas < ActiveRecord::Migration
  def self.up
  	Tipovivienda.create(:clave => "lamina", :descripcion => "Lámina", :activo => true) unless Tipovivienda.exists?(:clave => "lamina")
	  Tipovivienda.create(:clave => "concreto", :descripcion => "Concreto", :activo => true) unless Tipovivienda.exists?(:clave => "concreto")
	  Tipovivienda.create(:clave => "adobe", :descripcion => "Adobe", :activo => true) unless Tipovivienda.exists?(:clave => "adobe")
	  Tipovivienda.create(:clave => "carton", :descripcion => "Cartón", :activo => true) unless Tipovivienda.exists?(:clave => "carton")
	  Tipovivienda.create(:clave => "madera", :descripcion => "Madera", :activo => true) unless Tipovivienda.exists?(:clave => "madera")
	  Tipovivienda.create(:clave => "desconoce", :descripcion => "Se desconoce", :activo => true) unless Tipovivienda.exists?(:clave => "desconoce")

  	  FuenteIngreso.create(:clave => "ahorros", :descripcion => "Ahorros", :activo => true) unless FuenteIngreso.exists?(:clave => "ahorros")
	  FuenteIngreso.create(:clave => "herencia", :descripcion => "Herencias", :activo => true) unless FuenteIngreso.exists?(:clave => "herencia")
	  FuenteIngreso.create(:clave => "pension", :descripcion => "Pensiones", :activo => true) unless FuenteIngreso.exists?(:clave => "pension")
	  FuenteIngreso.create(:clave => "remesa", :descripcion => "Remesas", :activo => true) unless FuenteIngreso.exists?(:clave => "remesa")
	  FuenteIngreso.create(:clave => "renta", :descripcion => "Rentas", :activo => true) unless FuenteIngreso.exists?(:clave => "renta")
	  FuenteIngreso.create(:clave => "formal", :descripcion => "Trabajo Formal", :activo => true) unless FuenteIngreso.exists?(:clave => "formal")
	  FuenteIngreso.create(:clave => "informal", :descripcion => "Trabajo Informal", :activo => true) unless FuenteIngreso.exists?(:clave => "informal")
	  FuenteIngreso.create(:clave => "otro", :descripcion => "Otro", :activo => true) unless FuenteIngreso.exists?(:clave => "otro")
	  FuenteIngreso.create(:clave => "desconoce", :descripcion => "Se Desconoce", :activo => true) unless FuenteIngreso.exists?(:clave => "desconoce")


	  ServicioMedico.create(:clave => "imss", :descripcion => "IMSS", :activo => true) unless ServicioMedico.exists?(:clave => "imss")
	  ServicioMedico.create(:clave => "isstech", :descripcion => "ISSTECH", :activo => true) unless ServicioMedico.exists?(:clave => "isstech")
	  ServicioMedico.create(:clave => "issste", :descripcion => "ISSSTE", :activo => true) unless ServicioMedico.exists?(:clave => "issste")
	  ServicioMedico.create(:clave => "popular", :descripcion => "Seguro Popular", :activo => true) unless ServicioMedico.exists?(:clave => "popular")
	  ServicioMedico.create(:clave => "otro", :descripcion => "Otro", :activo => true) unless ServicioMedico.exists?(:clave => "otro")
	  ServicioMedico.create(:clave => "desconoce", :descripcion => "Se Desconoce", :activo => true) unless ServicioMedico.exists?(:clave => "desconoce")

	  Ocupacion.create(:clave => "funcionario", :descripcion => "Funcionarios, directores y jefes", :activo => true) unless Ocupacion.exists?(:clave => "funcionario")
	  Ocupacion.create(:clave => "profesionista", :descripcion => "Profesionistas y técnicos", :activo => true) unless Ocupacion.exists?(:clave => "profesionista")
	  Ocupacion.create(:clave => "auxiliar", :descripcion => "Trabajadores auxiliares en actividades administrativas", :activo => true) unless Ocupacion.exists?(:clave => "auxiliar")
	  Ocupacion.create(:clave => "comerciante", :descripcion => "Comerciantes, empleados en ventas y agentes de ventas", :activo => true) unless Ocupacion.exists?(:clave => "comerciante")
	  Ocupacion.create(:clave => "vigilancia", :descripcion => "Trabajadores en servicios personales y vigilancia", :activo => true) unless Ocupacion.exists?(:clave => "vigilancia")
	  Ocupacion.create(:clave => "agricola", :descripcion => "Trabajadores en actividades agrícolas, ganaderas, forestales, caza y pesca", :activo => true) unless Ocupacion.exists?(:clave => "agricola")
	  Ocupacion.create(:clave => "artesano", :descripcion => "Trabajadores artesanales", :activo => true) unless Ocupacion.exists?(:clave => "artesano")
	  Ocupacion.create(:clave => "operador", :descripcion => "Operadores de maquinaria industrial, ensambladores, choferes y conductores de transporte", :activo => true) unless Ocupacion.exists?(:clave => "operador")
	  Ocupacion.create(:clave => "apoyo", :descripcion => "Trabajadores en actividades elementales y de apoyo", :activo => true) unless Ocupacion.exists?(:clave => "apoyo")
	  Ocupacion.create(:clave => "policia", :descripcion => "Policías", :activo => true) unless Ocupacion.exists?(:clave => "policia")
	  Ocupacion.create(:clave => "estudiante", :descripcion => "Estudiantes", :activo => true) unless Ocupacion.exists?(:clave => "estudiante")
	  Ocupacion.create(:clave => "otro", :descripcion => "Otro", :activo => true) unless Ocupacion.exists?(:clave => "otro")
	  Ocupacion.create(:clave => "desconoce", :descripcion => "Se Desconoce", :activo => true) unless Ocupacion.exists?(:clave => "desconoce")

	  Alfabetismo.create(:clave => "leer", :descripcion => "Sabe leer pero no escribir", :activo => true) unless Alfabetismo.exists?(:clave => "leer")
	  Alfabetismo.create(:clave => "escribir", :descripcion => "Sabe escribir pero no leer", :activo => true) unless Alfabetismo.exists?(:clave => "escribir")
	  Alfabetismo.create(:clave => "analfabeta", :descripcion => "Analfabeta", :activo => true) unless Alfabetismo.exists?(:clave => "analfabeta")
	  Alfabetismo.create(:clave => "alfabeta", :descripcion => "Sabe leer y escribir", :activo => true) unless Alfabetismo.exists?(:clave => "alfabeta")
	  Alfabetismo.create(:clave => "desconoce", :descripcion => "Se desconoce", :activo => true) unless Alfabetismo.exists?(:clave => "desconoce")

	  EstadoPsicofisico.create(:clave => "ebrio", :descripcion => "Ebrio", :activo => true) unless EstadoPsicofisico.exists?(:clave => "ebrio")
	  EstadoPsicofisico.create(:clave => "drogado", :descripcion => "Drogado", :activo => true) unless EstadoPsicofisico.exists?(:clave => "drogado")
	  EstadoPsicofisico.create(:clave => "enuso", :descripcion => "En pleno uso de sus facultades mentales", :activo => true) unless EstadoPsicofisico.exists?(:clave => "enuso")
	  EstadoPsicofisico.create(:clave => "otro", :descripcion => "Otro", :activo => true) unless EstadoPsicofisico.exists?(:clave => "otro")
	  EstadoPsicofisico.create(:clave => "desconoce", :descripcion => "Se desconoce", :activo => true) unless EstadoPsicofisico.exists?(:clave => "desconoce")
	  EstadoPsicofisico.create(:clave => "noespecifica", :descripcion => "No especificado", :activo => true) unless EstadoPsicofisico.exists?(:clave => "noespecifica")

	  Tipoasesor.create(:clave => "defensor", :descripcion => "Defensor Social", :activo => true) unless Tipoasesor.exists?(:clave => "defensor")
	  Tipoasesor.create(:clave => "particular", :descripcion => "Defensor Particular", :activo => true) unless Tipoasesor.exists?(:clave => "particular")
	  Tipoasesor.create(:clave => "otro", :descripcion => "Otro", :activo => true) unless Tipoasesor.exists?(:clave => "otro")
	  Tipoasesor.create(:clave => "desconoce", :descripcion => "Se desconoce", :activo => true) unless Tipoasesor.exists?(:clave => "desconoce")

	  CalidadMigratoria.create(:clave => "documentada", :descripcion => "Documentada", :activo => true) unless CalidadMigratoria.exists?(:clave =>"documentada")
	  CalidadMigratoria.create(:clave => "indocumentada", :descripcion => "Indocumentada", :activo => true) unless CalidadMigratoria.exists?(:clave =>"indocumentada")
	  CalidadMigratoria.create(:clave => "otro", :descripcion => "Otro", :activo => true) unless CalidadMigratoria.exists?(:clave =>"otro")
	  CalidadMigratoria.create(:clave => "desconoce", :descripcion => "Se desconoce", :activo => true) unless CalidadMigratoria.exists?(:clave =>"desconoce")

	  EstatusMigratorio.create(:clave => "migrante", :descripcion => "Migrante", :activo => true) unless EstatusMigratorio.exists?(:clave =>"migrante")
	  EstatusMigratorio.create(:clave => "inmigrante", :descripcion => "Inmigrante", :activo => true) unless EstatusMigratorio.exists?(:clave =>"inmigrante")
	  EstatusMigratorio.create(:clave => "otro", :descripcion => "Otro", :activo => true) unless EstatusMigratorio.exists?(:clave =>"otro")
	  EstatusMigratorio.create(:clave => "desconoce", :descripcion => "Se desconoce", :activo => true) unless EstatusMigratorio.exists?(:clave =>"desconoce")

  end

  def self.down
  end
end
