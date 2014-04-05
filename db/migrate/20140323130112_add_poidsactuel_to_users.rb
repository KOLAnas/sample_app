class AddPoidsactuelToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :poids_actuel, :float
  end

  def self.down
    remove_column :users, :poids_actuel
  end
end
