class AddUniqueLogCountToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :unique_log_count, :integer, default:0
  end
end
