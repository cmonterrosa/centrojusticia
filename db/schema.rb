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

ActiveRecord::Schema.define(:version => 20120815144449) do

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

  create_table "attachments", :force => true do |t|
    t.integer  "size"
    t.integer  "height"
    t.integer  "width"
    t.integer  "parent_id"
    t.integer  "attachable_id"
    t.integer  "position"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["attachable_id", "attachable_type"], :name => "index_attachments_on_attachable_id_and_attachable_type"
  add_index "attachments", ["parent_id"], :name => "index_attachments_on_parent_id"

  create_table "comparecencias", :force => true do |t|
    t.datetime "fechahora"
    t.string   "procedencia",      :limit => 40
    t.string   "caracter",         :limit => 40
    t.integer  "hora_preferencia"
    t.integer  "dia_preferencia"
    t.boolean  "conocimiento"
    t.string   "datos",            :limit => 60
    t.text     "asunto"
    t.string   "observaciones"
    t.integer  "user_id"
    t.integer  "tramite_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comparecencias", ["user_id"], :name => "user"

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

  create_table "flujos", :force => true do |t|
    t.integer  "old_status_id"
    t.integer  "new_status_id"
    t.integer  "role_id"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "historias", :force => true do |t|
    t.integer  "tramite_id"
    t.integer  "estatu_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "historias", ["estatu_id"], :name => "estatus"
  add_index "historias", ["tramite_id"], :name => "tramite"

  create_table "invitacions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sesion_id"
    t.boolean  "entregada"
    t.string   "justificacion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitacions", ["sesion_id"], :name => "sesion"

  create_table "materias", :force => true do |t|
    t.string "descripcion", :limit => 60
  end

  create_table "materias_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "materia_id"
  end

  add_index "materias_users", ["materia_id"], :name => "index_materias_users_on_materia_id"
  add_index "materias_users", ["user_id"], :name => "index_materias_users_on_user_id"

  create_table "municipios", :force => true do |t|
    t.string "descripcion", :limit => 50
  end

  create_table "orientacions", :force => true do |t|
    t.datetime "fechahora"
    t.string   "observaciones"
    t.integer  "user_id"
    t.integer  "sala_id"
    t.string   "paterno",       :limit => 40
    t.string   "materno",       :limit => 40
    t.string   "nombre",        :limit => 60
    t.string   "sexo",          :limit => 1
    t.string   "direccion",     :limit => 60
    t.string   "telefono",      :limit => 10
    t.string   "correo",        :limit => 40
    t.integer  "municipio_id"
    t.integer  "tramite_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "participantes", :force => true do |t|
    t.string   "paterno",             :limit => 40
    t.string   "materno",             :limit => 40
    t.string   "nombre",              :limit => 60
    t.date     "fecha_nac"
    t.string   "sexo",                :limit => 1
    t.string   "domicilio",           :limit => 100
    t.string   "telefono_particular", :limit => 10
    t.string   "telefono_celular",    :limit => 10
    t.string   "correo",              :limit => 30
    t.integer  "municipio_id"
    t.integer  "user_id"
    t.integer  "comparecencia_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "title",      :limit => 100
    t.text     "content"
    t.integer  "tramite_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string  "descripcion", :limit => 40
    t.integer "capacidad"
    t.boolean "is_active",                 :default => true
  end

  create_table "sesions", :force => true do |t|
    t.string   "descripcion",       :limit => 60
    t.string   "observaciones"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "tramite_id"
    t.integer  "mediador_id"
    t.integer  "comediador_id"
    t.integer  "estatus_sesion_id",               :default => 1
  end

  add_index "sesions", ["comediador_id"], :name => "comediador"
  add_index "sesions", ["mediador_id"], :name => "mediador"
  add_index "sesions", ["start_at"], :name => "start_at_index"
  add_index "sesions", ["tramite_id"], :name => "tramite"

  create_table "subdireccions", :force => true do |t|
    t.string  "descripcion",   :limit => 60
    t.string  "titular",       :limit => 70
    t.string  "direccion",     :limit => 120
    t.string  "codigo_postal", :limit => 5
    t.string  "telefonos",     :limit => 40
    t.integer "municipio_id"
  end

  create_table "tipodocs", :force => true do |t|
    t.string "descripcion", :limit => 100
  end

  create_table "tramites", :force => true do |t|
    t.string   "anio",            :limit => 4
    t.string   "folio",           :limit => 6
    t.integer  "subdireccion_id"
    t.integer  "estatu_id"
    t.integer  "materia_id"
    t.integer  "user_id"
    t.datetime "fecha_fin"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "nombre",                    :limit => 100, :default => ""
    t.string   "paterno",                   :limit => 40
    t.string   "materno",                   :limit => 40
    t.string   "direccion",                 :limit => 120
    t.integer  "subdireccion_id",                          :default => 1
    t.boolean  "activo",                                   :default => true
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
