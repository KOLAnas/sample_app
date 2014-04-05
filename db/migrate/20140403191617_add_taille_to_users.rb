class AddTailleToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :taille, :float
  end

  def self.down
    remove_column :users, :taille
  end
end
