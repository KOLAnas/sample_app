class AddSporToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :spor, :boolean
  end

  def self.down
    remove_column :users, :spor
  end
end
