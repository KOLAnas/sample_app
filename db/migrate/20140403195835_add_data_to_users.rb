class AddDataToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :data, :binary
  end

  def self.down
    remove_column :users, :data
  end
end
