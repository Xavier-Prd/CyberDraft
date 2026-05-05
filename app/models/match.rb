class Match < ApplicationRecord
  # Un match appartient à un duel
  belongs_to :duel

  # Le gagnant est optionnel car il peut y avoir match nul (winner_id = nil)
  # class_name: "User" car la colonne s'appelle winner_id et non user_id
  belongs_to :winner, class_name: "User", optional: true

  # Un match contient les stats de chaque personnage ayant joué
  has_many :match_player_stats, dependent: :destroy

  # Les scores totaux doivent être des entiers positifs ou nuls
  validates :home_score, :away_score, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Les scores par quart-temps doivent aussi être des entiers positifs ou nuls
  validates :q1_home, :q1_away, :q2_home, :q2_away, :q3_home, :q3_away, :q4_home, :q4_away,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end
