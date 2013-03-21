class RebaseMigrations < ActiveRecord::Migration
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
  # It's strongly recommended to check this file into your version control system.
    create_table "raw_measurements", :force => true do |t|
      t.datetime "measurement_time"
      t.integer  "sensor_type"
      t.float    "value1"
      t.float    "value2"
      t.float    "value3"
      t.datetime "created_at",                     :null => false
      t.datetime "updated_at",                     :null => false
      t.integer  "source_id"
      t.float    "value4"
      t.float    "value5"
      t.float    "value6"
      t.float    "value7"
      t.float    "value8"
      t.float    "value9"
      t.float    "value10"
    end

    create_table "textloggers", :force => true do |t|
      t.text     "content"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
end
