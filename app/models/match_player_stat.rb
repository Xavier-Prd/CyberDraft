class MatchPlayerStat < ApplicationRecord
  # Une stat appartient à un match, un personnage et un joueur
  belongs_to :match
  belongs_to :character
  belongs_to :user

  # Les 5 postes du basket — un personnage joue à un poste précis pendant le match
  enum :position, { PG: "PG", SG: "SG", SF: "SF", PF: "PF", C: "C" }

  # Un personnage ne peut avoir qu'une seule ligne de stats par match
  # (il ne joue qu'une fois, même si il marque 50 points)
  validates :character_id, uniqueness: { scope: :match_id, message: "ce personnage a déjà des stats pour ce match" }

  # Toutes les stats doivent être des entiers positifs ou nuls (on peut faire 0 rebond)
  validates :points, :assists, :rebounds, :interceptions,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
