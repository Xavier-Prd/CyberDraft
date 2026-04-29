class CreateCharacters < ActiveRecord::Migration[8.1]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :universe
      t.string :recommanded_position
      t.integer :shoot
      t.integer :dunk
      t.integer :speed
      t.integer :defense
      t.integer :intelligence
      t.integer :strength
      t.integer :base_cost

      t.timestamps
    end
  end
end
