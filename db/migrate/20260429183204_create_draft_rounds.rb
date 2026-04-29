class CreateDraftRounds < ActiveRecord::Migration[8.1]
  def change
    create_table :draft_rounds do |t|
      t.references :duel, null: false, foreign_key: true
      t.integer :round_number
      t.datetime :home_validate_at
      t.datetime :away_validate_at

      t.timestamps
    end
  end
end
