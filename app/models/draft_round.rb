class DraftRound < ApplicationRecord
  # Un tour de draft appartient à un duel
  belongs_to :duel

  # Un tour contient les mises des deux joueurs sur les personnages
  has_many :bids, dependent: :destroy

  # Un tour produit des résultats (qui a remporté quel personnage)
  has_many :draft_results, dependent: :destroy

  # Le numéro de tour doit être un entier positif
  validates :round_number, numericality: { only_integer: true, greater_than: 0 }

  # On ne peut pas avoir deux tours avec le même numéro dans le même duel
  # scope: :duel_id signifie "unicité de round_number POUR UN duel donné"
  validates :round_number, uniqueness: { scope: :duel_id, message: "ce tour existe déjà pour ce duel" }

  # Retourne true si les deux joueurs ont validé leur tour
  def both_validated?
    home_validate_at.present? && away_validate_at.present?
  end
end
