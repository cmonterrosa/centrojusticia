# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140527173432) do

  create_table "adjuntos", :force => true do |t|
    t.string   "file_name",  :limit => 120
    t.string   "file_size",  :limit => 25
    t.string   "file_type",  :limit => 40
    t.integer  "tipodoc_id"
    t.integer  "tramite_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adjuntos", ["tipodoc_id"], :name => "tipodoc"
  add_index "adjuntos", ["tramite_id"], :name => "tramite"

  create_table "atencions", :force => true do |t|
    t.string "descripcion", :limit => 120
  end

  create_table "comparecencias", :force => true do |t|
    t.datetime "fechahora"
    t.string   "procedencia",      :limit => 40
    t.string   "caracter",         :limit => 70
    t.string   "hora_preferencia", :limit => 120
    t.string   "dia_preferencia",  :limit => 120
    t.boolean  "conocimiento"
    t.string   "datos",            :limit => 60
    t.text     "asunto"
    t.integer  "user_id"
    t.integer  "tramite_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comparecencias", ["tramite_id"], :name => "tramite_id"
  add_index "comparecencias", ["user_id"], :name => "user"

  create_table "configuracions", :force => true do |t|
    t.string "hora_cambio_turno", :limit => 15
    t.string "pie_pagina",        :limit => 120
  end

  create_table "cuadrantes", :force => true do |t|
    t.string  "descripcion",     :limit => 150
    t.integer "subdireccion_id"
  end

  create_table "cuadrantes_users", :id => false, :force => true do |t|
    t.integer "cuadrante_id"
    t.integer "user_id"
  end

  create_table "estatus", :force => true do |t|
    t.string  "descripcion", :limit => 40
    t.string  "clave",       :limit => 10
    t.boolean "is_default"
    t.boolean "is_finish"
  end

  add_index "estatus", ["clave"], :name => "clave_estatus"

  create_table "estatus_roles", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "estatu_id"
  end

  add_index "estatus_roles", ["estatu_id"], :name => "index_estatus_roles_on_estatu_id"
  add_index "estatus_roles", ["role_id"], :name => "index_estatus_roles_on_role_id"

  create_table "estatus_sesions", :force => true do |t|
    t.string "descripcion", :limit => 150
  end

  create_table "extraordinarias", :force => true do |t|
    t.string   "delito",          :limit => 120
    t.string   "num_expediente",  :limit => 25
    t.string   "termino",         :limit => 25
    t.string   "num_oficio",      :limit => 25
    t.string   "observaciones",   :limit => 180
    t.datetime "fechahora"
    t.string   "paterno",         :limit => 40
    t.string   "materno",         :limit => 40
    t.string   "nombre",          :limit => 60
    t.string   "sexo",            :limit => 1
    t.integer  "procedencia_id"
    t.integer  "user_id"
    t.integer  "especialista_id"
    t.integer  "tramite_id"
    t.boolean  "notificacion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "extraordinarias", ["num_expediente"], :name => "numero_expediente"
  add_index "extraordinarias", ["procedencia_id"], :name => "procedencia"
  add_index "extraordinarias", ["tramite_id"], :name => "tramites"

  create_table "flujos", :force => true do |t|
    t.integer  "old_status_id"
    t.integer  "new_status_id"
    t.integer  "role_id"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "orden"
  end

  add_index "flujos", ["old_status_id", "role_id"], :name => "busqueda_role"

  create_table "historias", :force => true do |t|
    t.integer  "tramite_id"
    t.integer  "estatu_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "justificacion_id"
    t.integer  "especialista_id"
  end

  add_index "historias", ["estatu_id"], :name => "estatus"
  add_index "historias", ["tramite_id"], :name => "tramite"

  create_table "horarios", :force => true do |t|
    t.integer "hora"
    t.integer "minutos"
    t.string  "descripcion", :limit => 30
    t.integer "sala_id"
    t.boolean "activo"
  end

  create_table "invitacions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sesion_id"
    t.boolean  "entregada"
    t.string   "justificacion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "fecha_hora_entrega"
    t.integer  "invitador_id"
    t.datetime "printed_at"
    t.integer  "participante_id"
  end

  add_index "invitacions", ["sesion_id"], :name => "sesion"

  create_table "justificacions", :force => true do |t|
    t.string "descripcion", :limit => 120
  end

  create_table "materias", :force => true do |t|
    t.string "descripcion", :limit => 60
  end

  create_table "materias_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "materia_id"
  end

  add_index "materias_users", ["materia_id"], :name => "index_materias_users_on_materia_id"
  add_index "materias_users", ["user_id"], :name => "index_materias_users_on_user_id"

  create_table "motivo_cancelacions", :force => true do |t|
    t.string "descripcion", :limit => 120
  end

  create_table "movimientos", :force => true do |t|
    t.integer  "situacion_id"
    t.integer  "user_id"
    t.integer  "autorizo"
    t.datetime "fecha_inicio"
    t.datetime "fecha_fin"
    t.string   "observaciones", :limit => 220
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "movimientos", ["situacion_id"], :name => "situacion"
  add_index "movimientos", ["user_id", "fecha_inicio", "fecha_fin"], :name => "busqueda"
  add_index "movimientos", ["user_id"], :name => "Usuario"

  create_table "municipios", :force => true do |t|
    t.string "descripcion", :limit => 50
  end

  create_table "noprocedentes", :force => true do |t|
    t.string "clave",       :limit => 8
    t.string "descripcion", :limit => 120
  end

  create_table "orientacions", :force => true do |t|
    t.datetime "fechahora"
    t.string   "observaciones"
    t.integer  "user_id"
    t.string   "paterno",         :limit => 40
    t.string   "materno",         :limit => 40
    t.string   "nombre",          :limit => 60
    t.string   "sexo",            :limit => 1
    t.string   "direccion",       :limit => 160
    t.string   "telefono",        :limit => 10
    t.string   "correo",          :limit => 40
    t.integer  "municipio_id"
    t.integer  "tramite_id"
    t.boolean  "notificacion"
    t.integer  "especialista_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orientacions", ["nombre", "tramite_id"], :name => "busqueda_nombre"
  add_index "orientacions", ["paterno", "tramite_id"], :name => "busqueda_paterno"
  add_index "orientacions", ["tramite_id", "nombre", "paterno"], :name => "search_nombre"

  create_table "participantes", :force => true do |t|
    t.string   "paterno",                 :limit => 40
    t.string   "materno",                 :limit => 40
    t.string   "nombre",                  :limit => 60
    t.date     "fecha_nac"
    t.string   "sexo",                    :limit => 1
    t.string   "domicilio"
    t.string   "telefono_particular",     :limit => 10
    t.string   "telefono_celular",        :limit => 10
    t.string   "correo",                  :limit => 30
    t.integer  "municipio_id"
    t.integer  "user_id"
    t.integer  "comparecencia_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "perfil",                  :limit => 20
    t.string   "telefono_celular_aux",    :limit => 20
    t.integer  "tipopersona_id"
    t.string   "referencia_domiciliaria"
    t.string   "razon_social",            :limit => 160
    t.text     "observaciones"
    t.string   "apoderado_legal",         :limit => 100
    t.string   "anio_nac",                :limit => 4
    t.integer  "cuadrante_id"
  end

  add_index "participantes", ["comparecencia_id", "perfil"], :name => "busqueda_perfil"
  add_index "participantes", ["comparecencia_id"], :name => "comparecencia"

  create_table "procedencias", :force => true do |t|
    t.string "descripcion", :limit => 150
  end

  create_table "roles", :force => true do |t|
    t.string  "name"
    t.string  "descripcion", :limit => 40
    t.integer "prioridad"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "salas", :force => true do |t|
    t.string  "descripcion",     :limit => 30
    t.integer "capacidad"
    t.boolean "is_active",                     :default => true
    t.integer "subdireccion_id"
  end

  create_table "sesions", :force => true do |t|
    t.string   "observaciones"
    t.string   "resultado",         :limit => 120
    t.string   "num_tramite",       :limit => 9
    t.string   "clave",             :limit => 6
    t.date     "fecha"
    t.integer  "hora"
    t.integer  "minutos"
    t.integer  "sala_id"
    t.integer  "tramite_id"
    t.integer  "mediador_id"
    t.integer  "comediador_id"
    t.integer  "horario_id"
    t.integer  "estatus_sesion_id"
    t.integer  "user_id"
    t.integer  "tiposesion_id"
    t.boolean  "activa"
    t.boolean  "notificacion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "signed_at"
    t.integer  "signer_id"
    t.boolean  "concluida"
    t.datetime "finished_at"
    t.integer  "cancel"
    t.integer  "cancel_user"
  end

  add_index "sesions", ["clave"], :name => "clave"
  add_index "sesions", ["comediador_id"], :name => "comediador"
  add_index "sesions", ["fecha"], :name => "fecha"
  add_index "sesions", ["hora", "minutos", "sala_id"], :name => "busqueda_diaria"
  add_index "sesions", ["horario_id"], :name => "horario"
  add_index "sesions", ["mediador_id"], :name => "mediador"
  add_index "sesions", ["tiposesion_id"], :name => "tiposesion"
  add_index "sesions", ["tramite_id"], :name => "tramite"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "situacions", :force => true do |t|
    t.string "descripcion", :limit => 60
  end

  create_table "subdireccions", :force => true do |t|
    t.string  "descripcion",   :limit => 60
    t.string  "titular",       :limit => 70
    t.string  "direccion",     :limit => 120
    t.string  "codigo_postal", :limit => 5
    t.string  "telefonos",     :limit => 40
    t.integer "municipio_id"
    t.string  "cargo",         :limit => 120
  end

  create_table "temporals", :force => true do |t|
    t.string   "numero_expediente", :limit => 20
    t.string   "materia_string",    :limit => 25
    t.integer  "materia_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipodocs", :force => true do |t|
    t.string "descripcion", :limit => 100
  end

  create_table "tipopersonas", :force => true do |t|
    t.string "descripcion", :limit => 12
  end

  create_table "tiposesions", :force => true do |t|
    t.string "descripcion", :limit => 40
  end

  create_table "tramites", :force => true do |t|
    t.string   "anio",                      :limit => 10
    t.integer  "folio"
    t.integer  "subdireccion_id"
    t.integer  "estatu_id"
    t.integer  "materia_id"
    t.integer  "user_id"
    t.datetime "fecha_fin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "only_orientacion"
    t.datetime "fechahora"
    t.integer  "folio_expediente"
    t.integer  "atencion_id"
    t.boolean  "procedente"
    t.string   "objeto_solicitud",          :limit => 140
    t.string   "observaciones_generales"
    t.string   "documentacion_anexa",       :limit => 160
    t.integer  "noprocedente_id"
    t.integer  "motivo_cancelacion_id"
    t.string   "cancelacion_observaciones", :limit => 120
  end

  add_index "tramites", ["anio", "folio"], :name => "busqueda"
  add_index "tramites", ["estatu_id"], :name => "estatus"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.datetime "last_login"
    t.string   "nombre",                    :limit => 100, :default => ""
    t.string   "paterno",                   :limit => 40
    t.string   "materno",                   :limit => 40
    t.string   "direccion",                 :limit => 120
    t.string   "tel_celular",               :limit => 11
    t.integer  "subdireccion_id"
    t.boolean  "activo"
    t.boolean  "admin",                                    :default => false
    t.string   "sexo",                      :limit => 1
    t.string   "categoria",                 :limit => 100
    t.integer  "situacion_id"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["situacion_id"], :name => "situacion"

end
