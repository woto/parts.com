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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111006203436) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "manufacturer_synonyms", :force => true do |t|
    t.string   "title",           :null => false
    t.integer  "manufacturer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "manufacturer_synonyms", ["title"], :name => "index_manufacturer_synonyms_on_title"

  create_table "manufacturers", :force => true do |t|
    t.integer  "parts_com_id", :null => false
    t.string   "title",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "manufacturers", ["title"], :name => "index_manufacturers_on_title"

  create_table "parts", :force => true do |t|
    t.string   "catalog_number",                        :null => false
    t.integer  "manufacturer_id",                       :null => false
    t.float    "price"
    t.datetime "price_checked"
    t.datetime "price_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "new_catalog_number"
    t.boolean  "locked",             :default => false, :null => false
  end

  add_index "parts", ["catalog_number"], :name => "index_parts_on_catalog_number"
  add_index "parts", ["manufacturer_id"], :name => "index_parts_on_manufacturer_id"
  add_index "parts", ["price_checked"], :name => "index_parts_on_price_checked"

  create_table "prices", :force => true do |t|
    t.string   "price",      :default => "0", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "file_size"
  end

  create_table "proxies", :force => true do |t|
    t.datetime "timestamp"
    t.string   "ip"
    t.string   "port"
    t.string   "country"
    t.integer  "speed"
    t.integer  "connection_time"
    t.string   "protocol"
    t.string   "anonymity"
    t.integer  "good",            :default => 0, :null => false
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "check"
  end

  add_index "proxies", ["ip"], :name => "index_proxies_on_ip"

end
