# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140522163546) do

  create_table "choferes", force: true do |t|
    t.string   "nombre"
    t.string   "apodo"
    t.integer  "estado_id"
    t.date     "fechaestado"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "credencial",  precision: 18, scale: 0
    t.decimal  "decimal",     precision: 18, scale: 0
    t.date     "vtocarnet"
    t.date     "date"
    t.string   "direccion"
    t.string   "telefono"
    t.string   "celular"
  end

  create_table "configuraciones", force: true do |t|
    t.date     "fecha_proceso"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cuentas", force: true do |t|
    t.integer  "chofer_id"
    t.integer  "movil_id"
    t.integer  "estado_id"
    t.decimal  "saldo_anterior", precision: 18, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cuentas", ["chofer_id"], name: "index_cuentas_on_chofer_id"
  add_index "cuentas", ["movil_id"], name: "index_cuentas_on_movil_id"

  create_table "derechos", force: true do |t|
    t.string   "nombre"
    t.string   "controller"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "derechos_roles", id: false, force: true do |t|
    t.integer "rol_id",     null: false
    t.integer "derecho_id", null: false
  end

  add_index "derechos_roles", ["derecho_id", "rol_id"], name: "index_derechos_roles_on_derecho_id_and_rol_id", unique: true

  create_table "documentos", force: true do |t|
    t.integer  "tipo_imagen_id"
    t.string   "imagen"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "documentable_id"
    t.string   "documentable_type"
  end

  add_index "documentos", ["documentable_id", "documentable_type"], name: "index_documentos_on_documentable_id_and_documentable_type"

  create_table "logs_estado", force: true do |t|
    t.string   "motivo"
    t.integer  "estado_id"
    t.integer  "estado_loggeable_id"
    t.string   "estado_loggeable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logs_estado", ["estado_loggeable_id", "estado_loggeable_type"], name: "idx_logs_estado_polymorphic"

  create_table "moviles", force: true do |t|
    t.integer  "nromovil"
    t.string   "marca"
    t.integer  "modelo"
    t.string   "dominio"
    t.integer  "estado_id"
    t.date     "fecha_estado"
    t.integer  "agencia_id"
    t.integer  "propietario_id"
    t.integer  "chofer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "moviles", ["agencia_id"], name: "index_moviles_on_agencia_id"
  add_index "moviles", ["chofer_id"], name: "index_moviles_on_chofer_id"
  add_index "moviles", ["estado_id"], name: "index_moviles_on_estado_id"
  add_index "moviles", ["propietario_id"], name: "index_moviles_on_propietario_id"

  create_table "movimientos", force: true do |t|
    t.integer  "transaccion_id"
    t.date     "fecha_movimiento"
    t.date     "fecha_proceso"
    t.string   "observacion"
    t.decimal  "importe",            precision: 18, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cuenta_id"
    t.boolean  "es_contrasiento",                             default: false
    t.datetime "fecha_contrasiento"
    t.datetime "datetime"
  end

  add_index "movimientos", ["cuenta_id"], name: "index_movimientos_on_cuenta_id"
  add_index "movimientos", ["transaccion_id"], name: "index_movimientos_on_transaccion_id"

  create_table "propietarios", force: true do |t|
    t.string   "nombre"
    t.integer  "nrodoc"
    t.integer  "tipo_doc_id"
    t.date     "fecha_alta"
    t.integer  "estado_id"
    t.date     "fecha_estado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "propietarios", ["estado_id"], name: "index_propietarios_on_estado_id"
  add_index "propietarios", ["tipo_doc_id"], name: "index_propietarios_on_tipo_doc_id"

  create_table "rellenos", force: true do |t|
    t.integer  "codigo"
    t.string   "descripcion"
    t.string   "sintetico"
    t.boolean  "habilitado"
    t.integer  "tipo_relleno_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rellenos", ["tipo_relleno_id"], name: "index_rellenos_on_tipo_relleno_id"

  create_table "roles", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_usuarios", id: false, force: true do |t|
    t.integer "usuario_id", null: false
    t.integer "rol_id",     null: false
  end

  add_index "roles_usuarios", ["rol_id", "usuario_id"], name: "index_roles_usuarios_on_rol_id_and_usuario_id", unique: true

  create_table "tipos_relleno", force: true do |t|
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "codigo"
  end

  create_table "transacciones", force: true do |t|
    t.string   "descripcion"
    t.string   "sintetico"
    t.boolean  "es_debito",   default: true
    t.boolean  "activo",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usuarios", force: true do |t|
    t.string   "nombre"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
