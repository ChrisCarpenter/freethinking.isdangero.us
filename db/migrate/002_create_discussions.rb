class CreateDiscussions < ActiveRecord::Migration
  def self.up
    create_table :discussions do |t|
      t.integer :post_id, :null => false
      t.string :name, :null => false
      t.string :email, :null => false
      t.string :url, :null => true
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :discussions
  end
end
