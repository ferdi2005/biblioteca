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

ActiveRecord::Schema.define(version: 2018_10_25_194047) do

  create_table "libri", force: :cascade do |t|
    t.string "titolo"
    t.string "autore"
    t.string "isbn"
    t.integer "utente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "costo"
    t.text "trama"
    t.string "foto"
    t.integer "voto"
    t.index ["utente_id"], name: "index_libri_on_utente_id"
  end

  create_table "prestiti", force: :cascade do |t|
    t.integer "utente_id"
    t.integer "libro_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "scadenza"
    t.integer "stato"
    t.datetime "consegna"
    t.text "recensione"
    t.integer "voto"
    t.index ["libro_id"], name: "index_prestiti_on_libro_id"
    t.index ["utente_id"], name: "index_prestiti_on_utente_id"
  end

  create_table "utenti", force: :cascade do |t|
    t.string "cognome"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

end
