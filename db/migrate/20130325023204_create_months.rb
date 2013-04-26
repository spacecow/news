class CreateMonths < ActiveRecord::Migration
  def change
    create_table :months do |t|
      t.string :name

      t.timestamps
    end
  end
end
