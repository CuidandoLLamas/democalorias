class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.integer :calories
      t.datetime :moment
      t.text :description

      t.timestamps null: false
    end
    
    add_index :meals,:moment
  end
end
