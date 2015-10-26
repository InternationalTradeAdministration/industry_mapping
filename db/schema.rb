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

ActiveRecord::Schema.define(version: 20_151_021_181_315) do
  create_table 'active_admin_comments', force: true do |t|
    t.string 'namespace'
    t.text 'body'
    t.string 'resource_id',   null: false
    t.string 'resource_type', null: false
    t.integer 'author_id'
    t.string 'author_type'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'active_admin_comments', %w(author_type author_id), name: 'index_active_admin_comments_on_author_type_and_author_id', using: :btree
  add_index 'active_admin_comments', ['namespace'], name: 'index_active_admin_comments_on_namespace', using: :btree
  add_index 'active_admin_comments', %w(resource_type resource_id), name: 'index_active_admin_comments_on_resource_type_and_resource_id', using: :btree

  create_table 'admin_users', force: true do |t|
    t.string 'email',                  default: '', null: false
    t.string 'encrypted_password',     default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count',          default: 0,  null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string 'current_sign_in_ip'
    t.string 'last_sign_in_ip'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'admin_users', ['email'], name: 'index_admin_users_on_email', unique: true, using: :btree
  add_index 'admin_users', ['reset_password_token'], name: 'index_admin_users_on_reset_password_token', unique: true, using: :btree

  create_table 'children', id: false, force: true do |t|
    t.integer 'term_a_id'
    t.integer 'term_b_id'
  end

  create_table 'mapped_terms', force: true do |t|
    t.string 'name'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.integer 'source_id',  null: false
  end

  add_index 'mapped_terms', %w(source_id name), name: 'index_mapped_terms_on_source_id_and_name', unique: true, using: :btree

  create_table 'parents', id: false, force: true do |t|
    t.integer 'term_b_id'
    t.integer 'term_a_id'
  end

  create_table 'sources', force: true do |t|
    t.string 'name'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'taxonomies', force: true do |t|
    t.string 'name'
    t.string 'protege_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'terms', force: true do |t|
    t.string 'name'
    t.string 'protege_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'terms_joined_mapped_terms', id: false, force: true do |t|
    t.integer 'term_id'
    t.integer 'mapped_term_id'
  end

  add_index 'terms_joined_mapped_terms', ['mapped_term_id'], name: 'index_terms_joined_mapped_terms_on_mapped_term_id', using: :btree
  add_index 'terms_joined_mapped_terms', ['term_id'], name: 'index_terms_joined_mapped_terms_on_term_id', using: :btree

  create_table 'terms_joined_taxonomies', id: false, force: true do |t|
    t.integer 'term_id'
    t.integer 'taxonomy_id'
  end

  add_index 'terms_joined_taxonomies', ['taxonomy_id'], name: 'index_terms_joined_taxonomies_on_taxonomy_id', using: :btree
  add_index 'terms_joined_taxonomies', ['term_id'], name: 'index_terms_joined_taxonomies_on_term_id', using: :btree
end
