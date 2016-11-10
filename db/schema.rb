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

ActiveRecord::Schema.define(version: 20161102154835) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administrateurs", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_token"
  end

  add_index "administrateurs", ["email"], name: "index_administrateurs_on_email", unique: true, using: :btree
  add_index "administrateurs", ["reset_password_token"], name: "index_administrateurs_on_reset_password_token", unique: true, using: :btree

  create_table "administrateurs_gestionnaires", id: false, force: :cascade do |t|
    t.integer "administrateur_id"
    t.integer "gestionnaire_id"
  end

  add_index "administrateurs_gestionnaires", ["administrateur_id"], name: "index_administrateurs_gestionnaires_on_administrateur_id", using: :btree
  add_index "administrateurs_gestionnaires", ["gestionnaire_id", "administrateur_id"], name: "unique_couple_administrateur_gestionnaire", unique: true, using: :btree
  add_index "administrateurs_gestionnaires", ["gestionnaire_id"], name: "index_administrateurs_gestionnaires_on_gestionnaire_id", using: :btree

  create_table "administrations", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "administrations", ["email"], name: "index_administrations_on_email", unique: true, using: :btree
  add_index "administrations", ["reset_password_token"], name: "index_administrations_on_reset_password_token", unique: true, using: :btree

  create_table "assign_tos", id: false, force: :cascade do |t|
    t.integer "gestionnaire_id"
    t.integer "procedure_id"
  end

  add_index "assign_tos", ["gestionnaire_id"], name: "index_assign_tos_on_gestionnaire_id", using: :btree
  add_index "assign_tos", ["procedure_id"], name: "index_assign_tos_on_procedure_id", using: :btree

  create_table "cadastres", force: :cascade do |t|
    t.string  "surface_intersection"
    t.float   "surface_parcelle"
    t.string  "numero"
    t.integer "feuille"
    t.string  "section"
    t.string  "code_dep"
    t.string  "nom_com"
    t.string  "code_com"
    t.string  "code_arr"
    t.text    "geometry"
    t.integer "dossier_id"
  end

  create_table "cerfas", force: :cascade do |t|
    t.string   "content"
    t.integer  "dossier_id"
    t.datetime "created_at"
    t.integer  "user_id"
    t.string   "original_filename"
    t.string   "content_secure_token"
  end

  add_index "cerfas", ["dossier_id"], name: "index_cerfas_on_dossier_id", using: :btree

  create_table "champs", force: :cascade do |t|
    t.string  "value"
    t.integer "type_de_champ_id"
    t.integer "dossier_id"
    t.string  "type"
  end

  add_index "champs", ["dossier_id"], name: "index_champs_on_dossier_id", using: :btree
  add_index "champs", ["type_de_champ_id"], name: "index_champs_on_type_de_champ_id", using: :btree

  create_table "commentaires", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at",             null: false
    t.string   "body"
    t.integer  "dossier_id"
    t.datetime "updated_at",             null: false
    t.integer  "piece_justificative_id"
  end

  add_index "commentaires", ["dossier_id"], name: "index_commentaires_on_dossier_id", using: :btree

  create_table "dossiers", force: :cascade do |t|
    t.boolean  "autorisation_donnees"
    t.string   "nom_projet"
    t.integer  "procedure_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.integer  "user_id"
    t.text     "json_latlngs"
    t.boolean  "archived",             default: false
    t.boolean  "mandataire_social",    default: false
    t.datetime "deposit_datetime"
  end

  add_index "dossiers", ["procedure_id"], name: "index_dossiers_on_procedure_id", using: :btree
  add_index "dossiers", ["user_id"], name: "index_dossiers_on_user_id", using: :btree

  create_table "drop_down_lists", force: :cascade do |t|
    t.string  "value"
    t.integer "type_de_champ_id"
  end

  add_index "drop_down_lists", ["type_de_champ_id"], name: "index_drop_down_lists_on_type_de_champ_id", using: :btree

  create_table "entreprises", force: :cascade do |t|
    t.string   "siren"
    t.integer  "capital_social"
    t.string   "numero_tva_intracommunautaire"
    t.string   "forme_juridique"
    t.string   "forme_juridique_code"
    t.string   "nom_commercial"
    t.string   "raison_sociale"
    t.string   "siret_siege_social"
    t.string   "code_effectif_entreprise"
    t.datetime "date_creation"
    t.string   "nom"
    t.string   "prenom"
    t.integer  "dossier_id"
  end

  add_index "entreprises", ["dossier_id"], name: "index_entreprises_on_dossier_id", using: :btree

  create_table "etablissements", force: :cascade do |t|
    t.string  "siret"
    t.boolean "siege_social"
    t.string  "naf"
    t.string  "libelle_naf"
    t.string  "adresse"
    t.string  "numero_voie"
    t.string  "type_voie"
    t.string  "nom_voie"
    t.string  "complement_adresse"
    t.string  "code_postal"
    t.string  "localite"
    t.string  "code_insee_localite"
    t.integer "dossier_id"
    t.integer "entreprise_id"
  end

  add_index "etablissements", ["dossier_id"], name: "index_etablissements_on_dossier_id", using: :btree

  create_table "exercices", force: :cascade do |t|
    t.string   "ca"
    t.datetime "dateFinExercice"
    t.integer  "date_fin_exercice_timestamp"
    t.integer  "etablissement_id"
  end

  create_table "follows", force: :cascade do |t|
    t.integer "gestionnaire_id"
    t.integer "dossier_id"
  end

  add_index "follows", ["dossier_id"], name: "index_follows_on_dossier_id", using: :btree
  add_index "follows", ["gestionnaire_id"], name: "index_follows_on_gestionnaire_id", using: :btree

  create_table "france_connect_informations", force: :cascade do |t|
    t.string  "gender"
    t.string  "given_name"
    t.string  "family_name"
    t.date    "birthdate"
    t.string  "birthplace"
    t.string  "france_connect_particulier_id"
    t.integer "user_id"
    t.string  "email_france_connect"
  end

  add_index "france_connect_informations", ["user_id"], name: "index_france_connect_informations_on_user_id", using: :btree

  create_table "gestionnaires", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "procedure_filter"
  end

  add_index "gestionnaires", ["email"], name: "index_gestionnaires_on_email", unique: true, using: :btree
  add_index "gestionnaires", ["reset_password_token"], name: "index_gestionnaires_on_reset_password_token", unique: true, using: :btree

  create_table "individuals", force: :cascade do |t|
    t.string  "nom"
    t.string  "prenom"
    t.string  "birthdate"
    t.integer "dossier_id"
    t.string  "gender"
  end

  add_index "individuals", ["dossier_id"], name: "index_individuals_on_dossier_id", using: :btree

  create_table "invites", force: :cascade do |t|
    t.string  "email"
    t.string  "email_sender"
    t.integer "dossier_id"
    t.integer "user_id"
    t.string  "type",         default: "InviteGestionnaire"
  end

  create_table "mail_templates", force: :cascade do |t|
    t.string  "object"
    t.text    "body"
    t.string  "type"
    t.integer "procedure_id"
  end

  create_table "module_api_cartos", force: :cascade do |t|
    t.integer "procedure_id"
    t.boolean "use_api_carto",          default: false
    t.boolean "quartiers_prioritaires", default: false
    t.boolean "cadastre",               default: false
  end

  add_index "module_api_cartos", ["procedure_id"], name: "index_module_api_cartos_on_procedure_id", unique: true, using: :btree

  create_table "pieces_justificatives", force: :cascade do |t|
    t.string   "content"
    t.integer  "dossier_id"
    t.integer  "type_de_piece_justificative_id"
    t.datetime "created_at"
    t.integer  "user_id"
    t.string   "original_filename"
    t.string   "content_secure_token"
  end

  add_index "pieces_justificatives", ["dossier_id"], name: "index_pieces_justificatives_on_dossier_id", using: :btree
  add_index "pieces_justificatives", ["type_de_piece_justificative_id"], name: "index_pieces_justificatives_on_type_de_piece_justificative_id", using: :btree

  create_table "preference_list_dossiers", force: :cascade do |t|
    t.string  "libelle"
    t.string  "table"
    t.string  "attr"
    t.string  "attr_decorate"
    t.string  "bootstrap_lg"
    t.string  "order"
    t.string  "filter"
    t.integer "gestionnaire_id"
    t.integer "procedure_id"
  end

  create_table "preference_smart_listing_pages", force: :cascade do |t|
    t.string  "liste"
    t.integer "page"
    t.integer "procedure_id"
    t.integer "gestionnaire_id"
  end

  create_table "procedure_paths", force: :cascade do |t|
    t.string  "path",              limit: 30
    t.integer "procedure_id"
    t.integer "administrateur_id"
  end

  add_index "procedure_paths", ["path"], name: "index_procedure_paths_on_path", using: :btree

  create_table "procedures", force: :cascade do |t|
    t.string   "libelle"
    t.string   "description"
    t.string   "organisation"
    t.string   "direction"
    t.string   "lien_demarche"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "test"
    t.integer  "administrateur_id"
    t.boolean  "archived",              default: false
    t.boolean  "euro_flag",             default: false
    t.string   "logo"
    t.boolean  "cerfa_flag",            default: false
    t.string   "logo_secure_token"
    t.boolean  "published",             default: false, null: false
    t.string   "lien_site_web"
    t.string   "lien_notice"
    t.boolean  "for_individual",        default: false
    t.boolean  "individual_with_siret", default: false
  end

  create_table "quartier_prioritaires", force: :cascade do |t|
    t.string  "code"
    t.string  "nom"
    t.string  "commune"
    t.text    "geometry"
    t.integer "dossier_id"
  end

  create_table "rna_informations", force: :cascade do |t|
    t.string  "association_id"
    t.string  "titre"
    t.text    "objet"
    t.date    "date_creation"
    t.date    "date_declaration"
    t.date    "date_publication"
    t.integer "entreprise_id"
  end

  add_index "rna_informations", ["entreprise_id"], name: "index_rna_informations_on_entreprise_id", using: :btree

  create_table "types_de_champ", force: :cascade do |t|
    t.string  "libelle"
    t.string  "type_champ"
    t.integer "order_place"
    t.integer "procedure_id"
    t.text    "description"
    t.boolean "mandatory",    default: false
    t.string  "type"
  end

  create_table "types_de_piece_justificative", force: :cascade do |t|
    t.string   "libelle"
    t.string   "description"
    t.boolean  "api_entreprise", default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "procedure_id"
    t.integer  "order_place"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                        default: "",      null: false
    t.string   "encrypted_password",           default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "siret"
    t.string   "loged_in_with_france_connect", default: "false"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "cerfas", "dossiers"
  add_foreign_key "commentaires", "dossiers"
  add_foreign_key "dossiers", "users"
  add_foreign_key "procedure_paths", "administrateurs"
  add_foreign_key "procedure_paths", "procedures"

  create_view :searches,  sql_definition: <<-SQL
      SELECT dossiers.id AS dossier_id,
      (((((((((((((((((((((((((((((((((((((((((((((((((((((((COALESCE(users.email, ''::character varying))::text || ' '::text) || (COALESCE(france_connect_informations.given_name, ''::character varying))::text) || ' '::text) || (COALESCE(france_connect_informations.family_name, ''::character varying))::text) || ' '::text) || (COALESCE(cerfas.content, ''::character varying))::text) || ' '::text) || (COALESCE(champs.value, ''::character varying))::text) || ' '::text) || (COALESCE(drop_down_lists.value, ''::character varying))::text) || ' '::text) || (COALESCE(entreprises.siren, ''::character varying))::text) || ' '::text) || (COALESCE(entreprises.numero_tva_intracommunautaire, ''::character varying))::text) || ' '::text) || (COALESCE(entreprises.forme_juridique, ''::character varying))::text) || ' '::text) || (COALESCE(entreprises.forme_juridique_code, ''::character varying))::text) || ' '::text) || (COALESCE(entreprises.nom_commercial, ''::character varying))::text) || ' '::text) || (COALESCE(entreprises.raison_sociale, ''::character varying))::text) || ' '::text) || (COALESCE(entreprises.siret_siege_social, ''::character varying))::text) || ' '::text) || (COALESCE(entreprises.nom, ''::character varying))::text) || ' '::text) || (COALESCE(entreprises.prenom, ''::character varying))::text) || ' '::text) || (COALESCE(rna_informations.association_id, ''::character varying))::text) || ' '::text) || (COALESCE(rna_informations.titre, ''::character varying))::text) || ' '::text) || COALESCE(rna_informations.objet, ''::text)) || ' '::text) || (COALESCE(etablissements.siret, ''::character varying))::text) || ' '::text) || (COALESCE(etablissements.naf, ''::character varying))::text) || ' '::text) || (COALESCE(etablissements.libelle_naf, ''::character varying))::text) || ' '::text) || (COALESCE(etablissements.adresse, ''::character varying))::text) || ' '::text) || (COALESCE(etablissements.code_postal, ''::character varying))::text) || ' '::text) || (COALESCE(etablissements.localite, ''::character varying))::text) || ' '::text) || (COALESCE(etablissements.code_insee_localite, ''::character varying))::text) || ' '::text) || (COALESCE(individuals.nom, ''::character varying))::text) || ' '::text) || (COALESCE(individuals.prenom, ''::character varying))::text) || ' '::text) || (COALESCE(pieces_justificatives.content, ''::character varying))::text) AS term
     FROM ((((((((((dossiers
       JOIN users ON ((users.id = dossiers.user_id)))
       LEFT JOIN france_connect_informations ON ((france_connect_informations.user_id = dossiers.user_id)))
       LEFT JOIN cerfas ON ((cerfas.dossier_id = dossiers.id)))
       LEFT JOIN champs ON ((champs.dossier_id = dossiers.id)))
       LEFT JOIN drop_down_lists ON ((drop_down_lists.type_de_champ_id = champs.type_de_champ_id)))
       LEFT JOIN entreprises ON ((entreprises.dossier_id = dossiers.id)))
       LEFT JOIN rna_informations ON ((rna_informations.entreprise_id = entreprises.id)))
       LEFT JOIN etablissements ON ((etablissements.dossier_id = dossiers.id)))
       LEFT JOIN individuals ON ((individuals.dossier_id = dossiers.id)))
       LEFT JOIN pieces_justificatives ON ((pieces_justificatives.dossier_id = dossiers.id)));
  SQL

end
