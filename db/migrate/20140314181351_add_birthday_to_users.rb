class AddBirthdayToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :date_naissance, :date
  end

  def self.down
    remove_column :users, :date_naissance
  end
end
