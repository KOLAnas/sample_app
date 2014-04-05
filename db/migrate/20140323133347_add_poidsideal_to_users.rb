class AddPoidsidealToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :poids_ideal, :float
  end

  def self.down
    remove_column :users, :poids_ideal
  end
end
