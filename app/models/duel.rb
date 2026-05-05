class Duel < ApplicationRecord
  # home_user = celui qui envoie le défi
  # away_user = celui qui le reçoit
  # class_name: "User" car les deux colonnes pointent vers la table users
  belongs_to :home_user, class_name: "User"
  belongs_to :away_user, class_name: "User"

  # Un duel se déroule en plusieurs tours de draft
  has_many :draft_rounds, dependent: :destroy

  # Un duel débouche sur un seul match à la fin de la draft
  has_one :match, dependent: :destroy

  # Les étapes de vie d'un duel :
  # pending  → défi envoyé, en attente de réponse
  # declined → défi refusé
  # draft    → défi accepté, la phase de draft est en cours
  # match    → draft terminée, le match est en cours de simulation
  # finished → match joué, duel terminé
  enum :status, {
    pending: "pending",
    declined: "declined",
    draft: "draft",
    match: "match",
    finished: "finished"
  }, default: "pending"

  # Les deux types de duel possibles pour l'instant
  # challenge   → défi envoyé à un ami
  # matchmaking → duel contre un inconnu via le système de matchmaking
  enum :origin, { challenge: "challenge", matchmaking: "matchmaking" }

  # Le budget doit être un entier strictement positif
  validates :budget, numericality: { only_integer: true, greater_than: 0 }

  # Empêche un user de se défier lui-même
  validate :no_self_duel

  private

  def no_self_duel
    errors.add(:away_user_id, "ne peut pas être vous-même") if home_user_id == away_user_id
  end
end
