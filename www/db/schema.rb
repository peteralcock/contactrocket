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

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "uuid-ossp"

  create_table "account_contacts", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "contact_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "account_contacts", ["account_id", "contact_id"], name: "index_account_contacts_on_account_id_and_contact_id", using: :btree

  create_table "account_opportunities", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "opportunity_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "account_opportunities", ["account_id", "opportunity_id"], name: "index_account_opportunities_on_account_id_and_opportunity_id", using: :btree

  create_table "accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "assigned_to"
    t.string   "name",             limit: 64,  default: "",        null: false
    t.string   "access",           limit: 8,   default: "Private"
    t.string   "website",          limit: 64
    t.string   "toll_free_phone",  limit: 32
    t.string   "phone",            limit: 32
    t.string   "fax",              limit: 32
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",            limit: 254
    t.string   "background_info"
    t.integer  "rating",                       default: 0,         null: false
    t.string   "category",         limit: 32
    t.text     "subscribed_users"
  end

  add_index "accounts", ["assigned_to"], name: "index_accounts_on_assigned_to", using: :btree
  add_index "accounts", ["user_id", "name", "deleted_at"], name: "index_accounts_on_user_id_and_name_and_deleted_at", unique: true, using: :btree

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.string   "action",         limit: 32, default: "created"
    t.string   "info",                      default: ""
    t.boolean  "private",                   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
  end

  add_index "activities", ["created_at"], name: "index_activities_on_created_at", using: :btree
  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.string   "street1"
    t.string   "street2"
    t.string   "city",             limit: 64
    t.string   "state",            limit: 64
    t.string   "zipcode",          limit: 16
    t.string   "country",          limit: 64
    t.string   "full_address"
    t.string   "address_type",     limit: 16
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], name: "index_addresses_on_addressable_id_and_addressable_type", using: :btree

  create_table "ahoy_messages", force: :cascade do |t|
    t.string   "token"
    t.text     "to"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "mailer"
    t.text     "subject"
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "clicked_at"
    t.integer  "campaign_id"
  end

  add_index "ahoy_messages", ["token"], name: "index_ahoy_messages_on_token", using: :btree
  add_index "ahoy_messages", ["user_id", "user_type"], name: "index_ahoy_messages_on_user_id_and_user_type", using: :btree

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.integer  "user_id"
    t.string   "name"
    t.datetime "date_expired"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", unique: true, using: :btree
  add_index "api_keys", ["user_id"], name: "index_api_keys_on_user_id", using: :btree

  create_table "attachinary_files", force: :cascade do |t|
    t.integer  "attachinariable_id"
    t.string   "attachinariable_type"
    t.string   "scope"
    t.string   "public_id"
    t.string   "version"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachinary_files", ["attachinariable_type", "attachinariable_id", "scope"], name: "by_scoped_parent", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.string   "file"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "function",        default: "website"
  end

  add_index "attachments", ["attachable_id"], name: "index_attachments_on_attachable_id", using: :btree

  create_table "authentication_tokens", force: :cascade do |t|
    t.string   "body"
    t.integer  "user_id"
    t.datetime "last_used_at"
    t.string   "ip_address"
    t.string   "user_agent"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "authentication_tokens", ["user_id"], name: "index_authentication_tokens_on_user_id", using: :btree

  create_table "avatars", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "entity_id"
    t.string   "entity_type"
    t.integer  "image_file_size"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "baits", force: :cascade do |t|
    t.string   "to"
    t.string   "from"
    t.string   "status"
    t.string   "message"
    t.integer  "blast_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blasts", force: :cascade do |t|
    t.integer  "campaign_id"
    t.boolean  "test",              default: false
    t.integer  "number_of_targets"
    t.integer  "emails_sent",       default: 0
    t.string   "message",           default: "Started  "
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "baits_count",       default: 0
  end

  create_table "bots", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "bot_type"
    t.string   "dict_file"
    t.integer  "aiml_id"
    t.integer  "brain_id"
    t.integer  "bot_iq"
    t.float    "brain_speed"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "brains", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "brain_type"
    t.integer  "brain_gender"
    t.string   "brain_aiml"
    t.integer  "aiml_id"
    t.float    "speed"
    t.string   "aiml_file"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "campaign_settings", force: :cascade do |t|
    t.integer  "campaign_id"
    t.string   "fqdn"
    t.string   "marketing_url"
    t.string   "apache_directory_root"
    t.string   "apache_directory_index"
    t.boolean  "track_uniq_visitors",    default: true
    t.boolean  "track_hits",             default: true
    t.boolean  "iptable_restrictions",   default: false
    t.boolean  "schedule_campaign",      default: false
    t.boolean  "use_beef",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "smtp_delay",             default: 0
    t.string   "beef_url"
    t.boolean  "ssl"
  end

  add_index "campaign_settings", ["campaign_id"], name: "index_campaign_settings_on_campaign_id", using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "assigned_to"
    t.string   "name",                limit: 64,                          default: "",        null: false
    t.string   "access",              limit: 8,                           default: "Private"
    t.string   "status",              limit: 64
    t.decimal  "budget",                         precision: 12, scale: 2
    t.integer  "target_leads"
    t.float    "target_conversion"
    t.decimal  "target_revenue",                 precision: 12, scale: 2
    t.integer  "leads_count"
    t.integer  "opportunities_count"
    t.decimal  "revenue",                        precision: 12, scale: 2
    t.date     "starts_on"
    t.date     "ends_on"
    t.text     "objectives"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "background_info"
    t.text     "subscribed_users"
    t.integer  "template_id"
    t.string   "description"
    t.boolean  "active",                                                  default: false
    t.integer  "scope"
    t.text     "emails"
    t.boolean  "email_sent",                                              default: false
    t.string   "test_email"
    t.integer  "admin_id"
  end

  add_index "campaigns", ["admin_id"], name: "index_campaigns_on_admin_id", using: :btree
  add_index "campaigns", ["assigned_to"], name: "index_campaigns_on_assigned_to", using: :btree
  add_index "campaigns", ["template_id"], name: "index_campaigns_on_template_id", using: :btree
  add_index "campaigns", ["user_id", "name", "deleted_at"], name: "index_campaigns_on_user_id_and_name_and_deleted_at", unique: true, using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "icon"
    t.string   "keywords"
    t.string   "title_tag"
    t.string   "meta_description"
    t.integer  "rank"
    t.boolean  "front_page",       default: false
    t.boolean  "active",           default: false
    t.string   "permalink"
    t.string   "section"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "template_id"
    t.string   "description"
    t.integer  "scope"
    t.text     "emails"
    t.boolean  "email_sent",       default: false
    t.string   "test_email"
    t.integer  "admin_id"
  end

  create_table "category_translations", force: :cascade do |t|
    t.integer  "category_id",      null: false
    t.string   "locale",           null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "name"
    t.string   "keywords"
    t.string   "title_tag"
    t.string   "meta_description"
  end

  add_index "category_translations", ["category_id"], name: "index_category_translations_on_category_id", using: :btree
  add_index "category_translations", ["locale"], name: "index_category_translations_on_locale", using: :btree

  create_table "change_password_user", force: :cascade do |t|
    t.integer  "create_uid"
    t.datetime "create_date"
    t.string   "user_login"
    t.string   "new_passwd"
    t.integer  "wizard_id",   null: false
    t.integer  "write_uid"
    t.datetime "write_date"
    t.integer  "user_id",     null: false
  end

  create_table "change_password_wizard", force: :cascade do |t|
    t.integer  "create_uid"
    t.datetime "create_date"
    t.integer  "write_uid"
    t.datetime "write_date"
  end

  create_table "clones", force: :cascade do |t|
    t.string   "name"
    t.string   "status"
    t.text     "url"
    t.text     "page"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.boolean  "private"
    t.string   "title",                       default: ""
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",            limit: 16, default: "Expanded", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "company_name",          limit: 255
    t.text     "address"
    t.string   "city",                  limit: 255
    t.string   "state",                 limit: 255
    t.string   "zip_code",              limit: 255
    t.string   "country",               limit: 255
    t.string   "gender",                limit: 255
    t.string   "phone_number",          limit: 255
    t.string   "fax_number",            limit: 255
    t.string   "contact_person",        limit: 255
    t.string   "contact_person_title",  limit: 255
    t.string   "website",               limit: 255
    t.integer  "employees_exact"
    t.float    "revenue_exact"
    t.string   "sic_code",              limit: 255
    t.string   "sic_code_description",  limit: 255
    t.string   "company_email_address", limit: 255
    t.string   "contact_person_email",  limit: 255
    t.string   "contact_person_phone",  limit: 255
    t.string   "contact_social",        limit: 255
    t.string   "category_1",            limit: 255
    t.string   "subcategory",           limit: 255
    t.string   "industry",              limit: 255
    t.text     "description"
    t.text     "important_people"
    t.string   "ownership",             limit: 255
    t.string   "note",                  limit: 255
    t.float    "media_spend"
    t.float    "social_score"
    t.text     "meta_data"
    t.string   "image_url",             limit: 255
    t.string   "domain",                limit: 255
    t.boolean  "active"
    t.datetime "last_processed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "entity_hash"
    t.text     "nlp_tags"
    t.string   "phone"
    t.string   "email"
    t.string   "fax"
    t.string   "alt_email"
    t.string   "mobile"
    t.string   "blog"
    t.string   "twitter"
    t.string   "linked_in"
    t.string   "facebook"
    t.string   "skype"
    t.string   "instagram"
    t.string   "pinterest"
  end

  create_table "contact_opportunities", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "opportunity_id"
    t.string   "role",           limit: 32
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contact_opportunities", ["contact_id", "opportunity_id"], name: "index_contact_opportunities_on_contact_id_and_opportunity_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "lead_id"
    t.integer  "assigned_to"
    t.integer  "reports_to"
    t.string   "first_name",       limit: 64,  default: "",        null: false
    t.string   "last_name",        limit: 64,  default: "",        null: false
    t.string   "access",           limit: 8,   default: "Private"
    t.string   "title",            limit: 64
    t.string   "department",       limit: 64
    t.string   "source",           limit: 32
    t.string   "email",            limit: 254
    t.string   "alt_email",        limit: 254
    t.string   "phone",            limit: 32
    t.string   "mobile",           limit: 32
    t.string   "fax",              limit: 32
    t.string   "blog",             limit: 128
    t.string   "linkedin",         limit: 128
    t.string   "facebook",         limit: 128
    t.string   "twitter",          limit: 128
    t.date     "born_on"
    t.boolean  "do_not_call",                  default: false,     null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "background_info"
    t.string   "skype",            limit: 128
    t.text     "subscribed_users"
  end

  add_index "contacts", ["assigned_to"], name: "index_contacts_on_assigned_to", using: :btree
  add_index "contacts", ["user_id", "last_name", "deleted_at"], name: "id_last_name_deleted", unique: true, using: :btree

  create_table "coupons", force: :cascade do |t|
    t.string   "code"
    t.string   "free_trial_length"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "crm_users", force: :cascade do |t|
    t.string   "username",            limit: 254, default: "",    null: false
    t.string   "email",               limit: 254, default: "",    null: false
    t.string   "first_name",          limit: 32
    t.string   "last_name",           limit: 32
    t.string   "title",               limit: 64
    t.string   "company",             limit: 64
    t.string   "alt_email",           limit: 254
    t.string   "phone",               limit: 32
    t.string   "mobile",              limit: 32
    t.string   "aim",                 limit: 32
    t.string   "yahoo",               limit: 32
    t.string   "google",              limit: 32
    t.string   "skype",               limit: 32
    t.string   "password_hash",                   default: "",    null: false
    t.string   "password_salt",                   default: "",    null: false
    t.string   "persistence_token",               default: "",    null: false
    t.string   "perishable_token",                default: "",    null: false
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.integer  "login_count",                     default: 0,     null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                           default: false, null: false
    t.datetime "suspended_at"
    t.string   "single_access_token"
    t.string   "uid"
  end

  add_index "crm_users", ["email"], name: "index_crm_users_on_email", using: :btree
  add_index "crm_users", ["perishable_token"], name: "index_crm_users_on_perishable_token", using: :btree
  add_index "crm_users", ["persistence_token"], name: "index_crm_users_on_persistence_token", using: :btree
  add_index "crm_users", ["username", "deleted_at"], name: "index_crm_users_on_username_and_deleted_at", unique: true, using: :btree

  create_table "doc_translations", force: :cascade do |t|
    t.integer  "doc_id",           null: false
    t.string   "locale",           null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "title"
    t.text     "body"
    t.string   "keywords"
    t.string   "title_tag"
    t.string   "meta_description"
  end

  add_index "doc_translations", ["doc_id"], name: "index_doc_translations_on_doc_id", using: :btree
  add_index "doc_translations", ["locale"], name: "index_doc_translations_on_locale", using: :btree

  create_table "docs", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.string   "keywords"
    t.string   "title_tag"
    t.string   "meta_description"
    t.integer  "category_id"
    t.integer  "user_id"
    t.boolean  "active",           default: true
    t.integer  "rank"
    t.string   "permalink"
    t.integer  "version"
    t.boolean  "front_page",       default: false
    t.boolean  "cheatsheet",       default: false
    t.integer  "points",           default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "topics_count",     default: 0
    t.boolean  "allow_comments",   default: true
    t.string   "attachments",      default: [],                 array: true
  end

  create_table "email_leads", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address",      limit: 255
    t.datetime "deleted_at"
    t.text     "original_url"
    t.text     "source_url"
    t.text     "academia"
    t.string   "domain",       limit: 255
    t.boolean  "is_valid"
    t.string   "govt_agency",  limit: 255
    t.text     "data_hash"
    t.integer  "person_id"
    t.integer  "company_id"
    t.integer  "website_id"
    t.integer  "user_id"
    t.float    "smart_score"
    t.string   "smart_tags"
    t.string   "state"
    t.string   "country"
    t.string   "govt"
    t.string   "organization"
    t.string   "title"
    t.string   "author"
    t.string   "description"
    t.string   "keywords"
    t.string   "smtp_reply"
    t.string   "image_url"
    t.json     "meta_data"
    t.text     "page_text"
    t.json     "nlp_json"
    t.json     "ner_json"
    t.json     "scores"
    t.text     "image_urls"
    t.text     "page_links"
    t.json     "page_tags"
  end

  add_index "email_leads", ["domain"], name: "index_email_leads_on_domain", using: :btree
  add_index "email_leads", ["user_id"], name: "index_email_leads_on_user_id", using: :btree
  add_index "email_leads", ["website_id"], name: "index_email_leads_on_website_id", using: :btree

  create_table "email_searches", force: :cascade do |t|
    t.string   "domain"
    t.integer  "crawls"
    t.integer  "harvested_email_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "email_searches", ["harvested_email_id"], name: "index_email_searches_on_harvested_email_id", using: :btree

  create_table "email_settings", force: :cascade do |t|
    t.integer  "campaign_id"
    t.string   "to"
    t.string   "cc"
    t.string   "bcc"
    t.string   "from"
    t.string   "display_from"
    t.string   "subject"
    t.string   "marketing_url"
    t.string   "smtp_server"
    t.string   "smtp_server_out"
    t.integer  "smtp_port"
    t.string   "smtp_username"
    t.string   "smtp_password"
    t.integer  "emails_sent",          default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "openssl_verify_mode"
    t.string   "domain"
    t.string   "authentication"
    t.boolean  "enable_starttls_auto"
    t.string   "reply_to"
  end

  add_index "email_settings", ["campaign_id"], name: "index_email_settings_on_campaign_id", using: :btree

  create_table "emails", force: :cascade do |t|
    t.string   "imap_message_id",                                 null: false
    t.integer  "user_id"
    t.integer  "mediator_id"
    t.string   "mediator_type"
    t.string   "sent_from",                                       null: false
    t.string   "sent_to",                                         null: false
    t.string   "cc"
    t.string   "bcc"
    t.string   "subject"
    t.text     "body"
    t.text     "header"
    t.datetime "sent_at"
    t.datetime "received_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",           limit: 16, default: "Expanded", null: false
  end

  add_index "emails", ["mediator_id", "mediator_type"], name: "index_emails_on_mediator_id_and_mediator_type", using: :btree

  create_table "field_groups", force: :cascade do |t|
    t.string   "name",       limit: 64
    t.string   "label",      limit: 128
    t.integer  "position"
    t.string   "hint"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag_id"
    t.string   "klass_name", limit: 32
  end

  create_table "fields", force: :cascade do |t|
    t.string   "type"
    t.integer  "field_group_id"
    t.integer  "position"
    t.string   "name",           limit: 64
    t.string   "label",          limit: 128
    t.string   "hint"
    t.string   "placeholder"
    t.string   "as",             limit: 32
    t.text     "collection"
    t.boolean  "disabled"
    t.boolean  "required"
    t.integer  "maxlength"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pair_id"
    t.text     "settings"
  end

  add_index "fields", ["field_group_id"], name: "index_fields_on_field_group_id", using: :btree
  add_index "fields", ["name"], name: "index_fields_on_name", using: :btree

  create_table "forums", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "topics_count",       default: 0,       null: false
    t.datetime "last_post_date"
    t.integer  "last_post_id"
    t.boolean  "private",            default: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "allow_topic_voting", default: false
    t.boolean  "allow_post_voting",  default: false
    t.string   "layout",             default: "table"
  end

  create_table "global_settings", force: :cascade do |t|
    t.string   "command_apache_restart"
    t.integer  "smtp_timeout",           default: 5
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "command_apache_status"
    t.string   "command_apache_vhosts",  default: "apache2ctl -S"
    t.boolean  "asynchronous",           default: true
    t.string   "bing_api"
    t.string   "beef_url"
    t.string   "sites_enabled_path",     default: "/etc/apache2/sites-enabled"
    t.integer  "reports_refresh",        default: 15
    t.string   "site_url",               default: "https://contactrocket.local"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  add_index "groups_users", ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id", using: :btree
  add_index "groups_users", ["group_id"], name: "index_groups_users_on_group_id", using: :btree
  add_index "groups_users", ["user_id"], name: "index_groups_users_on_user_id", using: :btree

  create_table "harvested_emails", force: :cascade do |t|
    t.string   "email"
    t.string   "group"
    t.text     "url"
    t.integer  "email_search_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "original"
  end

  add_index "harvested_emails", ["email_search_id"], name: "index_harvested_emails_on_email_search_id", using: :btree

  create_table "image_assets", force: :cascade do |t|
    t.text     "image_url"
    t.text     "source_url"
    t.text     "keywords"
    t.float    "sentiment"
    t.text     "description"
    t.string   "domain"
    t.integer  "website_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "key"
    t.string   "name"
    t.string   "extension"
    t.text     "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "koudoku_coupons", force: :cascade do |t|
    t.string   "code"
    t.string   "free_trial_length"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "koudoku_plans", force: :cascade do |t|
    t.string   "name"
    t.string   "stripe_id"
    t.float    "price"
    t.string   "interval"
    t.integer  "max_searches",    default: 10
    t.integer  "max_targets",     default: 10
    t.integer  "max_contacts",    default: 150
    t.integer  "max_validations", default: 0
    t.integer  "max_bandwidth",   default: 100000000
    t.integer  "max_pages",       default: 5000
    t.integer  "max_engines",     default: 2
    t.integer  "max_api_calls",   default: 5000
    t.text     "features"
    t.boolean  "highlight"
    t.integer  "display_order"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "koudoku_subscriptions", force: :cascade do |t|
    t.string   "stripe_id"
    t.integer  "plan_id"
    t.string   "last_four"
    t.integer  "coupon_id"
    t.string   "card_type"
    t.float    "current_price"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "leads", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "campaign_id"
    t.integer  "assigned_to"
    t.string   "first_name",       limit: 64,  default: "",        null: false
    t.string   "last_name",        limit: 64,  default: "",        null: false
    t.string   "access",           limit: 8,   default: "Private"
    t.string   "title",            limit: 64
    t.string   "company",          limit: 64
    t.string   "source",           limit: 32
    t.string   "status",           limit: 32
    t.string   "referred_by",      limit: 64
    t.string   "email",            limit: 254
    t.string   "alt_email",        limit: 254
    t.string   "phone",            limit: 32
    t.string   "mobile",           limit: 32
    t.string   "blog",             limit: 128
    t.string   "linkedin",         limit: 128
    t.string   "facebook",         limit: 128
    t.string   "twitter",          limit: 128
    t.integer  "rating",                       default: 0,         null: false
    t.boolean  "do_not_call",                  default: false,     null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "background_info"
    t.string   "skype",            limit: 128
    t.text     "subscribed_users"
  end

  add_index "leads", ["assigned_to"], name: "index_leads_on_assigned_to", using: :btree
  add_index "leads", ["user_id", "last_name", "deleted_at"], name: "index_leads_on_user_id_and_last_name_and_deleted_at", unique: true, using: :btree

  create_table "lists", force: :cascade do |t|
    t.string   "name"
    t.text     "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "lists", ["user_id"], name: "index_lists_on_user_id", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.text     "token",                               null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                          null: false
    t.string   "scopes"
    t.string   "previous_refresh_token", default: "", null: false
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "opportunities", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "campaign_id"
    t.integer  "assigned_to"
    t.string   "name",             limit: 64,                          default: "",        null: false
    t.string   "access",           limit: 8,                           default: "Private"
    t.string   "source",           limit: 32
    t.string   "stage",            limit: 32
    t.integer  "probability"
    t.decimal  "amount",                      precision: 12, scale: 2
    t.decimal  "discount",                    precision: 12, scale: 2
    t.date     "closes_on"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "background_info"
    t.text     "subscribed_users"
  end

  add_index "opportunities", ["assigned_to"], name: "index_opportunities_on_assigned_to", using: :btree
  add_index "opportunities", ["user_id", "name", "deleted_at"], name: "id_name_deleted", unique: true, using: :btree

  create_table "payola_affiliates", force: :cascade do |t|
    t.string   "code"
    t.string   "email"
    t.integer  "percent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payola_coupons", force: :cascade do |t|
    t.string   "code"
    t.integer  "percent_off"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",      default: true
  end

  create_table "payola_sales", force: :cascade do |t|
    t.string   "email",                limit: 191
    t.string   "guid",                 limit: 191
    t.integer  "product_id"
    t.string   "product_type",         limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.string   "stripe_id"
    t.string   "stripe_token"
    t.string   "card_last4"
    t.date     "card_expiration"
    t.string   "card_type"
    t.text     "error"
    t.integer  "amount"
    t.integer  "fee_amount"
    t.integer  "coupon_id"
    t.boolean  "opt_in"
    t.integer  "download_count"
    t.integer  "affiliate_id"
    t.text     "customer_address"
    t.text     "business_address"
    t.string   "stripe_customer_id",   limit: 191
    t.string   "currency"
    t.text     "signed_custom_fields"
    t.integer  "owner_id"
    t.string   "owner_type",           limit: 100
  end

  add_index "payola_sales", ["coupon_id"], name: "index_payola_sales_on_coupon_id", using: :btree
  add_index "payola_sales", ["email"], name: "index_payola_sales_on_email", using: :btree
  add_index "payola_sales", ["guid"], name: "index_payola_sales_on_guid", using: :btree
  add_index "payola_sales", ["owner_id", "owner_type"], name: "index_payola_sales_on_owner_id_and_owner_type", using: :btree
  add_index "payola_sales", ["product_id", "product_type"], name: "index_payola_sales_on_product", using: :btree
  add_index "payola_sales", ["stripe_customer_id"], name: "index_payola_sales_on_stripe_customer_id", using: :btree

  create_table "payola_stripe_webhooks", force: :cascade do |t|
    t.string   "stripe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payola_subscriptions", force: :cascade do |t|
    t.string   "plan_type"
    t.integer  "plan_id"
    t.datetime "start"
    t.string   "status"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "stripe_customer_id"
    t.boolean  "cancel_at_period_end"
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.datetime "ended_at"
    t.datetime "trial_start"
    t.datetime "trial_end"
    t.datetime "canceled_at"
    t.integer  "quantity"
    t.string   "stripe_id"
    t.string   "stripe_token"
    t.string   "card_last4"
    t.date     "card_expiration"
    t.string   "card_type"
    t.text     "error"
    t.string   "state"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency"
    t.integer  "amount"
    t.string   "guid",                 limit: 191
    t.string   "stripe_status"
    t.integer  "affiliate_id"
    t.string   "coupon"
    t.text     "signed_custom_fields"
    t.text     "customer_address"
    t.text     "business_address"
    t.integer  "setup_fee"
  end

  add_index "payola_subscriptions", ["guid"], name: "index_payola_subscriptions_on_guid", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "phone_number"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.datetime "birthdate"
    t.string   "title"
    t.string   "company"
    t.string   "ethnicity"
    t.string   "gender"
    t.float    "income"
    t.string   "facebook"
    t.string   "linkedin"
    t.string   "twitter"
    t.string   "instagram"
    t.string   "pinterest"
    t.string   "github"
    t.string   "google_plus"
    t.text     "summary"
    t.integer  "company_id"
    t.integer  "website_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "website"
    t.string   "domain"
    t.string   "image_url"
    t.string   "name"
    t.string   "location"
    t.text     "extra"
    t.string   "industry"
    t.integer  "face_rank"
    t.text     "face_tags"
    t.text     "image_tags"
    t.text     "profile_tags"
  end

  add_index "people", ["company_id"], name: "index_people_on_company_id", using: :btree
  add_index "people", ["website_id"], name: "index_people_on_website_id", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "asset_id"
    t.string   "asset_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

  add_index "permissions", ["asset_id", "asset_type"], name: "index_permissions_on_asset_id_and_asset_type", using: :btree
  add_index "permissions", ["group_id"], name: "index_permissions_on_group_id", using: :btree
  add_index "permissions", ["user_id"], name: "index_permissions_on_user_id", using: :btree

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "pghero_query_stats", force: :cascade do |t|
    t.text     "database"
    t.text     "user"
    t.text     "query"
    t.integer  "query_hash",  limit: 8
    t.float    "total_time"
    t.integer  "calls",       limit: 8
    t.datetime "captured_at"
  end

  add_index "pghero_query_stats", ["database", "captured_at"], name: "pghero_query_stats_database_captured_at_idx", using: :btree

  create_table "phone_leads", force: :cascade do |t|
    t.string   "number",       limit: 255
    t.text     "source_url"
    t.text     "original_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "country",      limit: 255
    t.string   "state",        limit: 255
    t.string   "domain",       limit: 255
    t.string   "area_code",    limit: 255
    t.boolean  "is_valid"
    t.string   "number_type",  limit: 255
    t.integer  "person_id"
    t.integer  "company_id"
    t.integer  "website_id"
    t.text     "data_hash"
    t.integer  "user_id"
    t.string   "location"
    t.string   "image_url"
    t.text     "smart_tags"
    t.string   "phone_type"
    t.string   "city"
    t.string   "organization"
    t.string   "title"
    t.string   "author"
    t.string   "description"
    t.string   "keywords"
    t.json     "meta_data"
    t.text     "page_text"
    t.json     "nlp_json"
    t.json     "ner_json"
    t.json     "scores"
    t.text     "image_urls"
    t.text     "page_links"
    t.json     "page_tags"
  end

  add_index "phone_leads", ["domain"], name: "index_phone_leads_on_domain", using: :btree
  add_index "phone_leads", ["user_id"], name: "index_phone_leads_on_user_id", using: :btree
  add_index "phone_leads", ["website_id"], name: "index_phone_leads_on_website_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.string   "stripe_id"
    t.float    "price"
    t.string   "interval"
    t.text     "features"
    t.integer  "max_searches",    default: 10
    t.integer  "max_targets",     default: 10
    t.integer  "max_contacts",    default: 150
    t.integer  "max_validations", default: 10
    t.integer  "max_bandwidth",   default: 100000000
    t.integer  "max_pages",       default: 5000
    t.integer  "max_engines",     default: 2
    t.integer  "max_api_calls",   default: 5000
    t.boolean  "highlight"
    t.integer  "display_order"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.text     "description"
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "user_id"
    t.text     "body"
    t.string   "kind"
    t.boolean  "active",      default: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "points",      default: 0
    t.string   "attachments", default: [],                array: true
  end

  create_table "preferences", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",       limit: 32, default: "", null: false
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "preferences", ["user_id", "name"], name: "index_preferences_on_user_id_and_name", using: :btree

  create_table "searches", force: :cascade do |t|
    t.string   "name"
    t.text     "body"
    t.string   "search_type"
    t.integer  "search_id"
    t.datetime "last_updated_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "searchjoy_searches", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "search_type"
    t.string   "query"
    t.string   "normalized_query"
    t.integer  "results_count"
    t.datetime "created_at"
    t.integer  "convertable_id"
    t.string   "convertable_type"
    t.datetime "converted_at"
  end

  add_index "searchjoy_searches", ["convertable_id", "convertable_type"], name: "index_searchjoy_searches_on_convertable_id_and_convertable_type", using: :btree
  add_index "searchjoy_searches", ["created_at"], name: "index_searchjoy_searches_on_created_at", using: :btree
  add_index "searchjoy_searches", ["search_type", "created_at"], name: "index_searchjoy_searches_on_search_type_and_created_at", using: :btree
  add_index "searchjoy_searches", ["search_type", "normalized_query", "created_at"], name: "index_searchjoy_searches_on_search_type_and_normalized_query", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "name",       limit: 32, default: "", null: false
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "var",                   default: "", null: false
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
  end

  add_index "settings", ["name"], name: "index_settings_on_name", using: :btree
  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "smtp_communications", force: :cascade do |t|
    t.string   "to"
    t.string   "from"
    t.string   "status"
    t.string   "string"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "smtp_communications", ["campaign_id"], name: "index_smtp_communications_on_campaign_id", using: :btree

  create_table "social_leads", force: :cascade do |t|
    t.string   "first_name",     limit: 255
    t.string   "last_name",      limit: 255
    t.string   "name",           limit: 255
    t.text     "source_url"
    t.text     "original_url"
    t.string   "profile_url",    limit: 255
    t.string   "social_network", limit: 255
    t.string   "phone_number",   limit: 255
    t.string   "address",        limit: 255
    t.string   "location",       limit: 255
    t.string   "city",           limit: 255
    t.string   "state",          limit: 255
    t.string   "country",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",       limit: 255
    t.string   "street",         limit: 255
    t.string   "zip",            limit: 255
    t.string   "website",        limit: 255
    t.string   "category",       limit: 255
    t.datetime "deleted_at"
    t.integer  "likes"
    t.integer  "mentions"
    t.integer  "followers"
    t.string   "email_address",  limit: 255
    t.string   "domain",         limit: 255
    t.string   "image_url",      limit: 255
    t.boolean  "is_valid"
    t.text     "data_hash"
    t.integer  "person_id"
    t.integer  "website_id"
    t.integer  "company_id"
    t.integer  "user_id"
    t.text     "smart_tags"
    t.string   "organization"
    t.string   "title"
    t.string   "author"
    t.string   "description"
    t.string   "keywords"
    t.json     "meta_data"
    t.text     "page_text"
    t.json     "nlp_json"
    t.json     "ner_json"
    t.text     "image_urls"
    t.text     "page_links"
    t.json     "page_tags"
  end

  add_index "social_leads", ["domain"], name: "index_social_leads_on_domain", using: :btree
  add_index "social_leads", ["user_id"], name: "index_social_leads_on_user_id", using: :btree
  add_index "social_leads", ["website_id"], name: "index_social_leads_on_website_id", using: :btree

  create_table "ssls", force: :cascade do |t|
    t.string   "filename"
    t.string   "function"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ssls", ["campaign_id"], name: "index_ssls_on_campaign_id", using: :btree

  create_table "statistics", force: :cascade do |t|
    t.integer  "campaign_id"
    t.string   "views"
    t.string   "downloads"
    t.string   "unique_visitors"
    t.string   "visitors_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string   "stripe_id"
    t.integer  "plan_id"
    t.string   "last_four"
    t.integer  "coupon_id"
    t.string   "card_type"
    t.float    "current_price"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tasks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "assigned_to"
    t.integer  "completed_by"
    t.string   "name",                        default: "", null: false
    t.integer  "asset_id"
    t.string   "asset_type"
    t.string   "priority",         limit: 32
    t.string   "category",         limit: 32
    t.string   "bucket",           limit: 32
    t.datetime "due_at"
    t.datetime "completed_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "background_info"
    t.text     "subscribed_users"
  end

  add_index "tasks", ["assigned_to"], name: "index_tasks_on_assigned_to", using: :btree
  add_index "tasks", ["user_id", "name", "deleted_at"], name: "index_tasks_on_user_id_and_name_and_deleted_at", unique: true, using: :btree

  create_table "templates", force: :cascade do |t|
    t.integer  "campaign_id"
    t.string   "name"
    t.string   "description"
    t.string   "location"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "directory_index"
    t.integer  "admin_id"
  end

  add_index "templates", ["admin_id"], name: "index_templates_on_admin_id", using: :btree
  add_index "templates", ["campaign_id"], name: "index_templates_on_campaign_id", using: :btree

  create_table "topics", force: :cascade do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "user_name"
    t.string   "name"
    t.integer  "posts_count",      default: 0,       null: false
    t.string   "waiting_on",       default: "admin", null: false
    t.datetime "last_post_date"
    t.datetime "closed_date"
    t.integer  "last_post_id"
    t.string   "current_status",   default: "new",   null: false
    t.boolean  "private",          default: false
    t.integer  "assigned_user_id"
    t.boolean  "cheatsheet",       default: false
    t.integer  "points",           default: 0
    t.text     "post_cache"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "locale"
    t.integer  "doc_id",           default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email",                              default: "",     null: false
    t.string   "first_name",             limit: 32
    t.string   "last_name",              limit: 32
    t.string   "title"
    t.string   "company"
    t.string   "alt_email",              limit: 254
    t.string   "phone",                  limit: 32
    t.string   "mobile",                 limit: 32
    t.string   "aim",                    limit: 32
    t.string   "yahoo",                  limit: 32
    t.string   "google",                 limit: 32
    t.string   "skype",                  limit: 32
    t.string   "password_hash",                      default: "",     null: false
    t.string   "password_salt"
    t.string   "persistence_token",                  default: "",     null: false
    t.string   "perishable_token",                   default: "",     null: false
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.integer  "login_count",                        default: 0,      null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.boolean  "admin",                              default: false
    t.datetime "suspended_at"
    t.string   "single_access_token"
    t.string   "encrypted_password",                 default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "nickname"
    t.string   "image"
    t.string   "name"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",                  default: 0
    t.integer  "subscription_plan"
    t.text     "image_url"
    t.string   "provider"
    t.string   "uid"
    t.string   "role",                               default: "user"
    t.integer  "plan_id"
    t.string   "authentication_token"
    t.integer  "crm_user_id"
    t.string   "login"
    t.string   "identity_url"
    t.text     "bio"
    t.text     "signature"
    t.string   "home_phone"
    t.string   "work_phone"
    t.string   "cell_phone"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "twitter"
    t.string   "linkedin"
    t.string   "thumbnail"
    t.string   "medium_image"
    t.string   "large_image"
    t.string   "language",                           default: "en"
    t.integer  "assigned_ticket_count",              default: 0
    t.integer  "topics_count",                       default: 0
    t.boolean  "active",                             default: true
    t.integer  "sign_in_count",                      default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.text     "invitation_message"
    t.string   "time_zone",                          default: "UTC"
    t.string   "profile_image"
    t.string   "password"
    t.string   "salt"
    t.string   "notes"
    t.boolean  "approved",                           default: true,   null: false
  end

  add_index "users", ["approved"], name: "index_users_on_approved", using: :btree
  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["perishable_token"], name: "index_users_on_perishable_token", using: :btree
  add_index "users", ["persistence_token"], name: "index_users_on_persistence_token", using: :btree
  add_index "users", ["plan_id"], name: "index_users_on_plan_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  add_index "users", ["username", "deleted_at"], name: "index_users_on_username_and_deleted_at", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.integer  "related_id"
    t.string   "related_type"
    t.integer  "transaction_id"
    t.string   "locale"
  end

  add_index "versions", ["created_at"], name: "index_versions_on_created_at", using: :btree
  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree
  add_index "versions", ["whodunnit"], name: "index_versions_on_whodunnit", using: :btree

  create_table "victims", force: :cascade do |t|
    t.string   "email_address"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
    t.string   "firstname"
    t.string   "lastname"
    t.boolean  "archive",       default: false
    t.boolean  "sent",          default: false
  end

  create_table "visits", force: :cascade do |t|
    t.integer  "victim_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "browser"
    t.string   "ip_address"
    t.string   "extra"
  end

  add_index "visits", ["victim_id"], name: "index_visits_on_victim_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "points",        default: 1
    t.string   "voteable_type"
    t.integer  "voteable_id"
    t.integer  "user_id",       default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "websites", force: :cascade do |t|
    t.string   "url",                limit: 255
    t.string   "domain",             limit: 255
    t.float    "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author"
    t.text     "meta"
    t.text     "whois"
    t.string   "image_url",          limit: 255
    t.boolean  "is_valid"
    t.integer  "email_leads_count",              default: 0, null: false
    t.integer  "phone_leads_count",              default: 0, null: false
    t.integer  "social_leads_count",             default: 0, null: false
    t.integer  "company_id"
    t.string   "title"
    t.text     "meta_keywords"
    t.integer  "user_id"
    t.text     "meta_description"
    t.text     "google_links"
    t.boolean  "is_active"
    t.text     "image_tags"
    t.string   "page_rank"
    t.string   "social_shares"
    t.string   "geoip"
  end

  add_foreign_key "authentication_tokens", "users"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
end
