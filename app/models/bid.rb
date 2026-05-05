class Bid < ApplicationRecord
  # Une mise appartient à un tour de draft, un joueur et un personnage
  belongs_to :draft_round
  belongs_to :user
  belongs_to :character

  # La mise doit être un entier strictement positif
  validates :amount, numericality: { only_integer: true, greater_than: 0 }

  # Un joueur ne peut miser qu'une seule fois sur le même personnage dans le même tour
  # scope: [:draft_round_id, :user_id] signifie "unicité de character_id POUR UN tour ET UN joueur donnés"
  validates :character_id, uniqueness: { scope: [ :draft_round_id, :user_id ], message: "vous avez déjà misé sur ce personnage ce tour" }

  # Retourne true si la mise a déjà été soumise (validated_at renseigné)
  # Utile pour bloquer toute modification après validation
  def submitted?
    submitted_at.present?
  end
end
