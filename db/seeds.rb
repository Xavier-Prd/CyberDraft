# On supprime toutes les données existantes dans le bon ordre
# (on commence par les tables dépendantes pour éviter les erreurs de clé étrangère)
puts "Nettoyage de la base de données..."
MatchPlayerStat.destroy_all
Match.destroy_all
DraftResult.destroy_all
Bid.destroy_all
DraftRound.destroy_all
Duel.destroy_all
Friendship.destroy_all
User.destroy_all
Character.destroy_all

# ============================================================
# PERSONNAGES
# Chaque personnage a des stats cohérentes avec sa personnalité
# Toutes les stats sont sur 100
# ============================================================
puts "Création des personnages..."

characters_data = [
  # --- Nier Replicant ---
  {
    name: "Nier",
    universe: "Nier Replicant",
    recommanded_position: "PF",
    base_cost: 100,
    speed: 75, shoot: 65, defense: 80, strength: 88, dunk: 72, intelligence: 70
  },
  {
    name: "Kainé",
    universe: "Nier Replicant",
    recommanded_position: "SF",
    base_cost: 110,
    speed: 88, shoot: 72, defense: 70, strength: 85, dunk: 80, intelligence: 68
  },

  # --- Nier Automata ---
  {
    name: "2B",
    universe: "Nier Automata",
    recommanded_position: "SF",
    base_cost: 130,
    speed: 92, shoot: 85, defense: 88, strength: 82, dunk: 78, intelligence: 85
  },
  {
    name: "9S",
    universe: "Nier Automata",
    recommanded_position: "PG",
    base_cost: 120,
    speed: 88, shoot: 80, defense: 72, strength: 65, dunk: 75, intelligence: 98
  },
  {
    name: "A2",
    universe: "Nier Automata",
    recommanded_position: "SG",
    base_cost: 125,
    speed: 95, shoot: 82, defense: 75, strength: 85, dunk: 88, intelligence: 75
  },

  # --- Naruto ---
  # Naruto : rapide et puissant, but de meneur naturel
  {
    name: "Naruto",
    universe: "Naruto",
    recommanded_position: "PG",
    base_cost: 130,
    speed: 92, shoot: 68, defense: 72, strength: 85, dunk: 82, intelligence: 65
  },
  # Sasuke : précis et intelligent, parfait arrière
  {
    name: "Sasuke",
    universe: "Naruto",
    recommanded_position: "SG",
    base_cost: 135,
    speed: 93, shoot: 88, defense: 78, strength: 80, dunk: 78, intelligence: 88
  },
  # Rock Lee : 0 technique mais physique pur — shoot catastrophique mais tout le reste au max
  {
    name: "Rock Lee",
    universe: "Naruto",
    recommanded_position: "PF",
    base_cost: 120,
    speed: 99, shoot: 40, defense: 85, strength: 95, dunk: 90, intelligence: 60
  },
  # Itachi : le plus cérébral de Naruto, défense et intelligence au sommet
  {
    name: "Itachi",
    universe: "Naruto",
    recommanded_position: "SF",
    base_cost: 140,
    speed: 88, shoot: 85, defense: 92, strength: 75, dunk: 72, intelligence: 99
  },

  # --- Dragon Ball ---
  # Goku : le plus fort physiquement, pivot naturel
  {
    name: "Goku",
    universe: "Dragon Ball",
    recommanded_position: "C",
    base_cost: 150,
    speed: 95, shoot: 70, defense: 75, strength: 99, dunk: 95, intelligence: 60
  },
  # Vegeta : presque aussi fort que Goku mais plus intelligent
  {
    name: "Vegeta",
    universe: "Dragon Ball",
    recommanded_position: "PF",
    base_cost: 140,
    speed: 90, shoot: 75, defense: 82, strength: 96, dunk: 88, intelligence: 72
  },
  # Gohan : plus équilibré, bon ailier
  {
    name: "Gohan",
    universe: "Dragon Ball",
    recommanded_position: "SF",
    base_cost: 120,
    speed: 85, shoot: 78, defense: 75, strength: 90, dunk: 82, intelligence: 82
  },

  # --- Kuroko no Basket ---
  # Kuroko : stats basses mais intelligence à 99 — le passeur fantôme
  {
    name: "Kuroko",
    universe: "Kuroko no Basket",
    recommanded_position: "PG",
    base_cost: 100,
    speed: 75, shoot: 65, defense: 70, strength: 55, dunk: 50, intelligence: 99
  },
  # Kagami : le dunker par excellence, pivot/ailier fort
  {
    name: "Kagami",
    universe: "Kuroko no Basket",
    recommanded_position: "C",
    base_cost: 130,
    speed: 85, shoot: 75, defense: 78, strength: 90, dunk: 99, intelligence: 72
  },
  # Aomine : le génie du street ball, meilleur scoreur
  {
    name: "Aomine",
    universe: "Kuroko no Basket",
    recommanded_position: "SG",
    base_cost: 155,
    speed: 97, shoot: 96, defense: 80, strength: 88, dunk: 92, intelligence: 85
  },
  # Akashi : le capitaine parfait, intelligence maximale
  {
    name: "Akashi",
    universe: "Kuroko no Basket",
    recommanded_position: "PG",
    base_cost: 160,
    speed: 90, shoot: 88, defense: 92, strength: 80, dunk: 78, intelligence: 100
  },

  # --- Saint Seiya ---
  # Seiya : rapide et courageux, meneur idéal
  {
    name: "Seiya",
    universe: "Saint Seiya",
    recommanded_position: "PG",
    base_cost: 125,
    speed: 95, shoot: 78, defense: 80, strength: 88, dunk: 85, intelligence: 72
  },
  # Shiryu : le plus défensif, ailier fort solide
  {
    name: "Shiryu",
    universe: "Saint Seiya",
    recommanded_position: "PF",
    base_cost: 120,
    speed: 78, shoot: 70, defense: 95, strength: 95, dunk: 80, intelligence: 85
  },

  # --- Amour Sucré ---
  # Castiel : le bad boy athlétique, agressif en attaque
  {
    name: "Castiel",
    universe: "Amour Sucré",
    recommanded_position: "SG",
    base_cost: 105,
    speed: 85, shoot: 82, defense: 75, strength: 80, dunk: 78, intelligence: 72
  },
  # Lysander : calme et posé, très intelligent, bon ailier fort
  {
    name: "Lysander",
    universe: "Amour Sucré",
    recommanded_position: "PF",
    base_cost: 95,
    speed: 70, shoot: 72, defense: 80, strength: 85, dunk: 75, intelligence: 90
  }
]

characters_data.each { |attrs| Character.create!(attrs) }
puts "#{Character.count} personnages créés"

# ============================================================
# USERS
# Faker génère des emails et noms réalistes aléatoires
# Mot de passe identique pour tous → facile pour tester
# ============================================================
puts "Création des utilisateurs..."

users = []
6.times do
  users << User.create!(
    email: Faker::Internet.unique.email,
    password: "password"
  )
end
puts "#{User.count} utilisateurs créés"

# ============================================================
# FRIENDSHIPS
# On crée quelques amitiés dans les deux sens + une en attente
# ============================================================
puts "Création des amitiés..."

# users[0] et users[1] sont amis (accepted)
Friendship.create!(sender: users[0], receiver: users[1], status: "accepted")
# users[2] a envoyé une demande à users[0] et il a accepté
Friendship.create!(sender: users[2], receiver: users[0], status: "accepted")
# users[1] et users[3] sont amis
Friendship.create!(sender: users[1], receiver: users[3], status: "accepted")
# users[4] a envoyé une demande à users[0] — toujours en attente
Friendship.create!(sender: users[4], receiver: users[0], status: "pending")

puts "#{Friendship.count} amitiés créées"

# ============================================================
# DUEL 1 — Terminé (finished)
# users[0] vs users[1] — 2 tours de draft + match joué
# ============================================================
puts "Création du duel terminé..."

duel1 = Duel.create!(
  home_user: users[0],
  away_user: users[1],
  status: "finished",
  budget: 1000,
  current_round: 2,
  origin: "challenge"
)

chars = Character.all.to_a

# --- Tour 1 du duel 1 ---
# home_validate_at et away_validate_at sont renseignés → les deux ont validé
round1 = DraftRound.create!(
  duel: duel1,
  round_number: 1,
  home_validate_at: 2.days.ago,
  away_validate_at: 2.days.ago + 5.minutes # users[1] a validé 5 min après users[0]
)

# Mises de users[0] — tour 1
Bid.create!(draft_round: round1, user: users[0], character: chars[9],  amount: 200, submitted_at: 2.days.ago) # Goku
Bid.create!(draft_round: round1, user: users[0], character: chars[10], amount: 150, submitted_at: 2.days.ago) # Vegeta
Bid.create!(draft_round: round1, user: users[0], character: chars[5],  amount: 120, submitted_at: 2.days.ago) # Naruto
Bid.create!(draft_round: round1, user: users[0], character: chars[14], amount: 100, submitted_at: 2.days.ago) # Aomine
Bid.create!(draft_round: round1, user: users[0], character: chars[16], amount: 80,  submitted_at: 2.days.ago) # Seiya

# Mises de users[1] — tour 1
Bid.create!(draft_round: round1, user: users[1], character: chars[9],  amount: 180, submitted_at: 2.days.ago + 5.minutes) # Goku — users[0] gagne (200 > 180)
Bid.create!(draft_round: round1, user: users[1], character: chars[10], amount: 160, submitted_at: 2.days.ago + 5.minutes) # Vegeta — users[1] gagne (160 > 150)
Bid.create!(draft_round: round1, user: users[1], character: chars[6],  amount: 140, submitted_at: 2.days.ago + 5.minutes) # Sasuke
Bid.create!(draft_round: round1, user: users[1], character: chars[15], amount: 110, submitted_at: 2.days.ago + 5.minutes) # Akashi
Bid.create!(draft_round: round1, user: users[1], character: chars[2],  amount: 90,  submitted_at: 2.days.ago + 5.minutes) # 2B

# Résultats du tour 1
# Goku : users[0]=200 vs users[1]=180 → users[0] gagne
DraftResult.create!(draft_round: round1, character: chars[9],  winner: users[0], winning_amount: 200, tie_broken_by_time: false)
# Vegeta : users[0]=150 vs users[1]=160 → users[1] gagne
DraftResult.create!(draft_round: round1, character: chars[10], winner: users[1], winning_amount: 160, tie_broken_by_time: false)
# Naruto : users[0] seul → users[0] gagne
DraftResult.create!(draft_round: round1, character: chars[5],  winner: users[0], winning_amount: 120, tie_broken_by_time: false)
# Aomine : users[0] seul → users[0] gagne
DraftResult.create!(draft_round: round1, character: chars[14], winner: users[0], winning_amount: 100, tie_broken_by_time: false)
# Seiya : users[0] seul → users[0] gagne
DraftResult.create!(draft_round: round1, character: chars[16], winner: users[0], winning_amount: 80,  tie_broken_by_time: false)
# Sasuke : users[1] seul → users[1] gagne
DraftResult.create!(draft_round: round1, character: chars[6],  winner: users[1], winning_amount: 140, tie_broken_by_time: false)
# Akashi : users[1] seul → users[1] gagne
DraftResult.create!(draft_round: round1, character: chars[15], winner: users[1], winning_amount: 110, tie_broken_by_time: false)
# 2B : users[1] seul → users[1] gagne
DraftResult.create!(draft_round: round1, character: chars[2],  winner: users[1], winning_amount: 90,  tie_broken_by_time: false)

# --- Tour 2 du duel 1 ---
round2 = DraftRound.create!(
  duel: duel1,
  round_number: 2,
  home_validate_at: 1.day.ago,
  away_validate_at: 1.day.ago + 2.minutes
)

# Mises de users[0] — tour 2
Bid.create!(draft_round: round2, user: users[0], character: chars[11], amount: 130, submitted_at: 1.day.ago) # Gohan
Bid.create!(draft_round: round2, user: users[0], character: chars[12], amount: 110, submitted_at: 1.day.ago) # Kuroko
Bid.create!(draft_round: round2, user: users[0], character: chars[7],  amount: 100, submitted_at: 1.day.ago) # Rock Lee
Bid.create!(draft_round: round2, user: users[0], character: chars[17], amount: 80,  submitted_at: 1.day.ago) # Shiryu
Bid.create!(draft_round: round2, user: users[0], character: chars[0],  amount: 60,  submitted_at: 1.day.ago) # Nier

# Mises de users[1] — tour 2
Bid.create!(draft_round: round2, user: users[1], character: chars[11], amount: 120, submitted_at: 1.day.ago + 2.minutes) # Gohan — users[0] gagne
Bid.create!(draft_round: round2, user: users[1], character: chars[3],  amount: 115, submitted_at: 1.day.ago + 2.minutes) # 9S
Bid.create!(draft_round: round2, user: users[1], character: chars[4],  amount: 100, submitted_at: 1.day.ago + 2.minutes) # A2
Bid.create!(draft_round: round2, user: users[1], character: chars[13], amount: 90,  submitted_at: 1.day.ago + 2.minutes) # Kagami
Bid.create!(draft_round: round2, user: users[1], character: chars[18], amount: 70,  submitted_at: 1.day.ago + 2.minutes) # Castiel

# Résultats du tour 2
DraftResult.create!(draft_round: round2, character: chars[11], winner: users[0], winning_amount: 130, tie_broken_by_time: false) # Gohan → users[0]
DraftResult.create!(draft_round: round2, character: chars[12], winner: users[0], winning_amount: 110, tie_broken_by_time: false) # Kuroko → users[0]
DraftResult.create!(draft_round: round2, character: chars[7],  winner: users[0], winning_amount: 100, tie_broken_by_time: false) # Rock Lee → users[0]
DraftResult.create!(draft_round: round2, character: chars[17], winner: users[0], winning_amount: 80,  tie_broken_by_time: false) # Shiryu → users[0]
DraftResult.create!(draft_round: round2, character: chars[0],  winner: users[0], winning_amount: 60,  tie_broken_by_time: false) # Nier → users[0]
DraftResult.create!(draft_round: round2, character: chars[3],  winner: users[1], winning_amount: 115, tie_broken_by_time: false) # 9S → users[1]
DraftResult.create!(draft_round: round2, character: chars[4],  winner: users[1], winning_amount: 100, tie_broken_by_time: false) # A2 → users[1]
DraftResult.create!(draft_round: round2, character: chars[13], winner: users[1], winning_amount: 90,  tie_broken_by_time: false) # Kagami → users[1]
DraftResult.create!(draft_round: round2, character: chars[18], winner: users[1], winning_amount: 70,  tie_broken_by_time: false) # Castiel → users[1]

# --- Match du duel 1 ---
# users[0] a gagné le match
# Équipe users[0] : Goku(C), Naruto(PG), Aomine(SG), Seiya(SF), Gohan(PF) — + Kuroko, Rock Lee, Shiryu, Nier en remplaçants
# Équipe users[1] : Vegeta(PF), Sasuke(SG), Akashi(PG), 2B(SF), 9S(C) — + A2, Kagami, Castiel en remplaçants
match = Match.create!(
  duel: duel1,
  winner: users[0],
  home_score: 102,
  away_score: 89,
  q1_home: 28, q1_away: 22,
  q2_home: 25, q2_away: 24,
  q3_home: 27, q3_away: 21,
  q4_home: 22, q4_away: 22,
  narrative: "Un match dominé par Goku et Aomine côté home. Akashi a tenté de renverser la tendance au 3ème quart mais la défense de Shiryu a tenu bon.",
  played_at: 1.day.ago
)

# Stats des 5 titulaires de users[0]
MatchPlayerStat.create!(match: match, user: users[0], character: chars[9],  position: "C",  points: 32, assists: 4,  rebounds: 14, interceptions: 2) # Goku
MatchPlayerStat.create!(match: match, user: users[0], character: chars[5],  position: "PG", points: 18, assists: 11, rebounds: 3,  interceptions: 3) # Naruto
MatchPlayerStat.create!(match: match, user: users[0], character: chars[14], position: "SG", points: 28, assists: 5,  rebounds: 4,  interceptions: 4) # Aomine
MatchPlayerStat.create!(match: match, user: users[0], character: chars[16], position: "SF", points: 14, assists: 3,  rebounds: 6,  interceptions: 2) # Seiya
MatchPlayerStat.create!(match: match, user: users[0], character: chars[11], position: "PF", points: 10, assists: 2,  rebounds: 10, interceptions: 1) # Gohan

# Stats des 5 titulaires de users[1]
MatchPlayerStat.create!(match: match, user: users[1], character: chars[10], position: "PF", points: 22, assists: 3,  rebounds: 11, interceptions: 2) # Vegeta
MatchPlayerStat.create!(match: match, user: users[1], character: chars[6],  position: "SG", points: 20, assists: 6,  rebounds: 3,  interceptions: 5) # Sasuke
MatchPlayerStat.create!(match: match, user: users[1], character: chars[15], position: "PG", points: 24, assists: 13, rebounds: 2,  interceptions: 3) # Akashi
MatchPlayerStat.create!(match: match, user: users[1], character: chars[2],  position: "SF", points: 15, assists: 4,  rebounds: 5,  interceptions: 4) # 2B
MatchPlayerStat.create!(match: match, user: users[1], character: chars[3],  position: "C",  points: 8,  assists: 2,  rebounds: 8,  interceptions: 1) # 9S

puts "Duel 1 terminé créé (#{DraftRound.count} tours, #{Bid.count} mises, #{DraftResult.count} résultats, #{Match.count} match)"

# ============================================================
# DUEL 2 — En cours de draft (draft)
# users[2] vs users[3] — 1 tour en cours, users[2] a déjà misé
# ============================================================
puts "Création du duel en cours de draft..."

duel2 = Duel.create!(
  home_user: users[2],
  away_user: users[3],
  status: "draft",
  budget: 1000,
  current_round: 1,
  origin: "matchmaking"
)

# Tour en cours — aucun des deux n'a encore validé (pas de validate_at)
round_in_progress = DraftRound.create!(
  duel: duel2,
  round_number: 1
)

# users[2] a déjà placé ses mises (submitted_at = nil car pas encore validé)
Bid.create!(draft_round: round_in_progress, user: users[2], character: chars[1],  amount: 200) # Kainé
Bid.create!(draft_round: round_in_progress, user: users[2], character: chars[8],  amount: 150) # Itachi
Bid.create!(draft_round: round_in_progress, user: users[2], character: chars[19], amount: 120) # Lysander
Bid.create!(draft_round: round_in_progress, user: users[2], character: chars[4],  amount: 100) # A2
Bid.create!(draft_round: round_in_progress, user: users[2], character: chars[13], amount: 80)  # Kagami

puts "Duel 2 en cours créé"

# ============================================================
# DUEL 3 — En attente de réponse (pending)
# users[4] a défié users[5], pas encore accepté
# ============================================================
puts "Création du duel en attente..."

Duel.create!(
  home_user: users[4],
  away_user: users[5],
  status: "pending",
  budget: 1000,
  current_round: 0,
  origin: "challenge"
)

puts "Duel 3 en attente créé"

# ============================================================
# RÉSUMÉ FINAL
# ============================================================
puts ""
puts "Seeds terminées !"
puts "  Users          : #{User.count}"
puts "  Characters     : #{Character.count}"
puts "  Friendships    : #{Friendship.count}"
puts "  Duels          : #{Duel.count}"
puts "  Draft Rounds   : #{DraftRound.count}"
puts "  Bids           : #{Bid.count}"
puts "  Draft Results  : #{DraftResult.count}"
puts "  Matches        : #{Match.count}"
puts "  Player Stats   : #{MatchPlayerStat.count}"
