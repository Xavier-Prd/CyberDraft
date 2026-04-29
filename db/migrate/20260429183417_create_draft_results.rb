class CreateDraftResults < ActiveRecord::Migration[8.1]
  def change
    create_table :draft_results do |t|
      t.references :draft_round, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true
      t.references :winner, null: false, foreign_key: { to_table: :users }
      t.integer :winning_amount
      t.boolean :tie_broken_by_time

      t.timestamps
    end
  end
end
