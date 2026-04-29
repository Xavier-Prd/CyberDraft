class CreateDuels < ActiveRecord::Migration[8.1]
  def change
    create_table :duels do |t|
      t.references :home_user, null: false, foreign_key: { to_table: :users }
      t.references :away_user, null: false, foreign_key: { to_table: :users }
      t.string :status
      t.string :origin
      t.integer :budget
      t.integer :current_round

      t.timestamps
    end
  end
end
