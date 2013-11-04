class AddForemanUsers < ActiveRecord::Migration
  def up
    create_table "users", :force => true do |t|
      t.string   "login"
      t.string   "firstname"
      t.string   "lastname"
      t.string   "mail"
      t.boolean  "admin"
      t.datetime "last_login_on"
      t.integer  "auth_source_id"
      t.datetime "created_at",                                                    :null => false
      t.datetime "updated_at",                                                    :null => false
      t.string   "password_hash",               :limit => 128
      t.string   "password_salt",               :limit => 128
      t.string   "domains_andor",               :limit => 3,   :default => "or"
      t.string   "hostgroups_andor",            :limit => 3,   :default => "or"
      t.string   "facts_andor",                 :limit => 3,   :default => "or"
      t.boolean  "filter_on_owner"
      t.string   "compute_resources_andor",     :limit => 3,   :default => "or"
      t.string   "organizations_andor",         :limit => 3,   :default => "or"
      t.string   "locations_andor",             :limit => 3,   :default => "or"
      t.boolean  "subscribe_to_all_hostgroups"
      t.string   "locale",                      :limit => 5
      t.boolean  "helptips_enabled",                           :default => true
      t.boolean  "hidden",                                     :default => false, :null => false
      t.integer  "page_size",                                  :default => 25,    :null => false
      t.boolean  "disabled",                                   :default => false
      t.text     "preferences"
      t.string   "remote_id"
      t.integer  "default_environment_id"
    end
  end

  def down
    drop_table :users
  end
end
