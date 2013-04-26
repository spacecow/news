class AddCategoryIdToLogs < ActiveRecord::Migration
  def self.up 
    add_column :logs, :category_id, :integer 
    remove_column :logs, :category
  end

  def self.down 
    remove_column :logs, :category_id
    add_column :logs, :category, :string
  end
end
