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

ActiveRecord::Schema.define(version: 20191204063951) do

  create_table "lines", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "productions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "date"
    t.integer  "product_id"
    t.integer  "line_id"
    t.integer  "begin_box1"
    t.integer  "begin_box2"
    t.integer  "begin_box3"
    t.integer  "begin_box4"
    t.integer  "begin_box5"
    t.integer  "begin_box6"
    t.integer  "begin_box7"
    t.integer  "begin_box8"
    t.integer  "begin_box9"
    t.integer  "begin_box10"
    t.integer  "begin_box11"
    t.integer  "begin_box12"
    t.integer  "begin_box13"
    t.integer  "begin_box14"
    t.integer  "begin_box15"
    t.integer  "begin_box16"
    t.integer  "begin_box17"
    t.integer  "begin_box18"
    t.integer  "begin_box19"
    t.integer  "begin_box20"
    t.integer  "begin_box21"
    t.integer  "begin_box22"
    t.integer  "begin_box23"
    t.integer  "begin_box24"
    t.integer  "end_box1"
    t.integer  "end_box2"
    t.integer  "end_box3"
    t.integer  "end_box4"
    t.integer  "end_box5"
    t.integer  "end_box6"
    t.integer  "end_box7"
    t.integer  "end_box8"
    t.integer  "end_box9"
    t.integer  "end_box10"
    t.integer  "end_box11"
    t.integer  "end_box12"
    t.integer  "end_box13"
    t.integer  "end_box14"
    t.integer  "end_box15"
    t.integer  "end_box16"
    t.integer  "end_box17"
    t.integer  "end_box18"
    t.integer  "end_box19"
    t.integer  "end_box20"
    t.integer  "end_box21"
    t.integer  "end_box22"
    t.integer  "end_box23"
    t.integer  "end_box24"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["line_id"], name: "index_productions_on_line_id", using: :btree
    t.index ["product_id"], name: "index_productions_on_product_id", using: :btree
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "code",       null: false
    t.string   "name",       null: false
    t.integer  "per_case",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "productions", "lines"
  add_foreign_key "productions", "products"
end
