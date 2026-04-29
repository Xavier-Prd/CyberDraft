class CreateBids < ActiveRecord::Migration[8.1]
  def change
    create_table :bids do |t|
      t.references :draft_round, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true
      t.integer :amount
      t.datetime :submitted_at

      t.timestamps
    end
  end
end
