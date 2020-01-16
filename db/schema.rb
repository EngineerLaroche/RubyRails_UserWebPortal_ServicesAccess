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

ActiveRecord::Schema.define(version: 20180411225936) do

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "encryption_organisme_referents", force: :cascade do |t|
    t.string "encrypted_nom"
    t.string "encrypted_email"
    t.string "encrypted_tel"
    t.string "encrypted_fax"
    t.string "encrypted_no_civique"
    t.string "encrypted_rue"
    t.string "encrypted_ville"
    t.string "encrypted_province"
    t.string "encrypted_code_postal"
    t.string "encrypted_website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "encryption_organismes", force: :cascade do |t|
    t.string "encrypted_email"
    t.string "encrypted_tel"
    t.string "encrypted_fax"
    t.string "encrypted_no_civique"
    t.string "encrypted_rue"
    t.string "encrypted_ville"
    t.string "encrypted_province"
    t.string "encrypted_code_postal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "encryption_point_of_services", force: :cascade do |t|
    t.string "encrypted_nom"
    t.string "encrypted_email"
    t.string "encrypted_tel"
    t.string "encrypted_fax"
    t.string "encrypted_no_civique"
    t.string "encrypted_rue"
    t.string "encrypted_ville"
    t.string "encrypted_province"
    t.string "encrypted_code_postal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "encryption_referents", force: :cascade do |t|
    t.string "encrypted_email"
    t.string "encrypted_tel_bureau"
    t.string "encrypted_tel_cell"
    t.string "encrypted_fax"
    t.string "encrypted_nom"
    t.string "encrypted_prenom"
    t.string "encrypted_titre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "encryption_services", force: :cascade do |t|
    t.string "encrypted_nom"
    t.string "encrypted_description"
    t.string "encrypted_tarification_parent"
    t.string "encrypted_tarification_cisss"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "encryption_un_locals", force: :cascade do |t|
    t.string "encrypted_nom"
    t.string "encrypted_qte_places"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follows", force: :cascade do |t|
    t.string "followable_type", null: false
    t.integer "followable_id", null: false
    t.string "follower_type", null: false
    t.integer "follower_id", null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followable_id", "followable_type"], name: "fk_followables"
    t.index ["followable_type", "followable_id"], name: "index_follows_on_followable_type_and_followable_id"
    t.index ["follower_id", "follower_type"], name: "fk_follows"
    t.index ["follower_type", "follower_id"], name: "index_follows_on_follower_type_and_follower_id"
  end

  create_table "organisme_referents", force: :cascade do |t|
    t.string "nom"
    t.string "courriel"
    t.string "site_web"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "no_civique"
    t.string "rue"
    t.string "ville"
    t.string "province"
    t.string "code_postal"
    t.string "tel"
    t.string "fax"
    t.string "email"
    t.string "website"
    t.boolean "est_actif", default: true
    t.boolean "activated", default: true
    t.datetime "activated_at"
    t.integer "organismes_id"
    t.index ["nom"], name: "index_organisme_referents_on_nom", unique: true
    t.index ["organismes_id"], name: "index_organisme_referents_on_organismes_id"
  end

  create_table "organismes", force: :cascade do |t|
    t.string "nom"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tel"
    t.string "fax"
    t.string "no_civique"
    t.string "rue"
    t.string "ville"
    t.string "province"
    t.string "code_postal"
    t.boolean "est_actif", default: true
    t.boolean "activated", default: true
    t.datetime "activated_at"
    t.index ["nom"], name: "index_organismes_on_nom", unique: true
  end

  create_table "point_of_services", force: :cascade do |t|
    t.string "nom"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tel"
    t.string "fax"
    t.string "no_civique"
    t.string "rue"
    t.string "ville"
    t.string "province"
    t.string "code_postal"
    t.integer "organismes_id"
    t.boolean "activated", default: true
    t.datetime "activated_at"
    t.index ["nom"], name: "index_point_of_services_on_nom", unique: true
    t.index ["organismes_id"], name: "index_point_of_services_on_organismes_id"
  end

  create_table "referents", force: :cascade do |t|
    t.string "nom"
    t.string "prenom"
    t.string "titre"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "activated", default: true
    t.datetime "activated_at"
    t.string "tel_bureau"
    t.string "tel_cell"
    t.string "fax"
    t.string "pref_rapport_1"
    t.string "pref_rapport_2"
    t.string "pref_rapport_3"
    t.integer "organismes_id"
    t.index ["email"], name: "index_referents_on_email", unique: true
    t.index ["organismes_id"], name: "index_referents_on_organismes_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "nom"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tarification_parent"
    t.integer "tarification_cisss"
    t.boolean "est_actif", default: true
    t.boolean "activated", default: true
    t.datetime "activated_at"
    t.integer "point_of_services_id"
    t.integer "un_locals_id"
    t.boolean "est_subventionnee", default: false
    t.date "date_entree_vigueur"
    t.boolean "sera_subventionnee", default: false
    t.integer "futur_tarification_parent"
    t.integer "futur_tarification_cisss"
    t.index ["nom"], name: "index_services_on_nom", unique: true
    t.index ["point_of_services_id"], name: "index_Services_on_point_of_services_id"
    t.index ["un_locals_id"], name: "index_services_on_un_locals_id"
  end

  create_table "un_locals", force: :cascade do |t|
    t.string "nom"
    t.string "qte_places"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "est_disponible", default: true
    t.boolean "activated", default: true
    t.datetime "activated_at"
    t.integer "point_of_services_id"
    t.string "qte_services"
    t.index ["nom"], name: "index_un_locals_on_nom", unique: true
    t.index ["point_of_services_id"], name: "index_un_locals_on_point_of_services_id"
  end

  create_table "user_details", force: :cascade do |t|
    t.string "encrypted_email"
    t.string "encrypted_password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean "supression", default: true
    t.string "role"
    t.integer "sign_in_count"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
