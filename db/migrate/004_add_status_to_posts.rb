class AddStatusToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :status, :integer
  end

  def self.down
    remove_column :posts, :status
  end
end
