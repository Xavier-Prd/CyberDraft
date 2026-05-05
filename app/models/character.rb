class Character < ApplicationRecord
  # Un personnage peut recevoir des mises de plusieurs joueurs sur plusieurs tours
  has_many :bids, dependent: :destroy
  # Un personnage peut avoir été remporté dans plusieurs résultats de draft
  has_many :draft_results, dependent: :destroy

  # Les 5 postes officiels du basket
  # PG = meneur, SG = arrière, SF = ailier, PF = ailier fort, C = pivot
  enum :recommanded_position, { PG: "PG", SG: "SG", SF: "SF", PF: "PF", C: "C" }

  # Tous les champs texte doivent être remplis
  validates :name, :universe, :recommanded_position, presence: true

  # Le coût de base doit être un entier positif (prix minimum en draft)
  validates :base_cost, numericality: { only_integer: true, greater_than: 0 }

  # Chaque stat doit être un entier entre 1 et 100
  validates :speed, :shoot, :defense, :strength, :dunk, :intelligence,
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 100 }
end
