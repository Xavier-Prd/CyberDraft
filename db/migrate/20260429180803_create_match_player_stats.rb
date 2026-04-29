class CreateMatchPlayerStats < ActiveRecord::Migration[8.1]
  def change
    create_table :match_player_stats do |t|
      t.references :match, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :position
      t.integer :points
      t.integer :rebounds
      t.integer :interceptions
      t.integer :assists

      t.timestamps
    end
  end
end
