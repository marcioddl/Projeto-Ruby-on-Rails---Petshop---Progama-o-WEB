# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_12_13_185025) do
  create_table "animais", charset: "utf8mb3", force: :cascade do |t|
    t.string "nome"
    t.string "especie"
    t.string "raca"
    t.integer "idade"
    t.bigint "dono_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "foto"
    t.index ["dono_id"], name: "index_animais_on_dono_id"
  end

  create_table "atendimentos", charset: "utf8mb3", force: :cascade do |t|
    t.datetime "data", precision: nil
    t.text "descricao"
    t.bigint "animal_id", null: false
    t.bigint "funcionario_id", bull: false
    t.bigint "servico_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["animal_id"], name: "index_atendimentos_on_animal_id"
    t.index ["funcionario_id"], name: "index_atendimentos_on_funcionarios_id"
    t.index ["servico_id"], name: "index_atendimentos_on_servico_id"
  end


  create_table "documentos", charset: "utf8mb3", force: :cascade do |t|
    t.string "nome"
    t.text "descricao"
    t.string "arquivo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "donos", charset: "utf8mb3", force: :cascade do |t|
    t.string "nome"
    t.string "email", null: false
    t.string "telefone"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "endereco"
    t.index ["cpf"], name: "index_donos_on_cpf", unique: true
  end

  create_table "funcionarios", charset: "utf8mb3", force: :cascade do |t|
    t.string "nome"
    t.string "funcao"
    t.string "telefone"
    t.string "registro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  
  create_table "servicos", charset: "utf8mb3", force: :cascade do |t|
    t.string "nome"
    t.text "descricao"
    t.decimal "preco", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "animais", "donos"
  add_foreign_key "atendimentos", "animais", column: "animal_id"
  add_foreign_key "atendimentos", "funcionarios"
  add_foreign_key "atendimentos", "servicos"
  add_foreign_key "atendimentos_servicos", "atendimentos"
  add_foreign_key "atendimentos_servicos", "servicos"
  add_foreign_key "funcionarios_servicos", "funcionarios"
  add_foreign_key "funcionarios_servicos", "servicos"
end
