class CreateMatches < ActiveRecord::Migration[8.1]
  def change
    create_table :matches do |t|
      t.references :duel, null: false, foreign_key: true
      t.references :winner, foreign_key: { to_table: :users }
      t.integer :home_score
      t.integer :away_score
      t.text :narrative
      t.datetime :played_at
      t.integer :q1_home
      t.integer :q2_home
      t.integer :q3_home
      t.integer :q4_home
      t.integer :q1_away
      t.integer :q2_away
      t.integer :q3_away
      t.integer :q4_away

      t.timestamps
    end
  end
end
