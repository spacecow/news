class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :log_count, default: 0
      t.integer :month_id

      t.timestamps
    end
  end
end
