class DraftResult < ApplicationRecord
  # Un résultat appartient à un tour de draft
  belongs_to :draft_round

  # Le personnage qui a été remporté lors de ce résultat
  belongs_to :character

  # Le joueur qui a remporté l'enchère sur ce personnage
  # class_name: "User" car la colonne s'appelle winner_id et non user_id
  belongs_to :winner, class_name: "User"

  # Le montant gagnant doit être un entier strictement positif
  validates :winning_amount, numericality: { only_integer: true, greater_than: 0 }

  # Un personnage ne peut être remporté qu'une seule fois par tour
  # scope: :draft_round_id signifie "unicité de character_id POUR UN tour donné"
  validates :character_id, uniqueness: { scope: :draft_round_id, message: "ce personnage a déjà un gagnant pour ce tour" }
end
