# Cyber Draft

Fantasy basketball draft game où des joueurs s'affrontent en draftant des personnages issus d'univers anime et gaming via un système d'enchères secrètes simultanées.

---

## Stack

- Ruby on Rails 7
- PostgreSQL
- Déployé sur Heroku

---

## Concept métier

Deux joueurs s'affrontent dans un **duel**. Chaque duel est composé de plusieurs **draft rounds** : à chaque round, les deux joueurs enchérissent secrètement sur un personnage avec un budget identique. L'offre la plus haute remporte le personnage. En cas d'égalité, le timestamp départage.

Une fois les deux équipes constituées, un **match** est simulé avec des statistiques basketball et une narration générée.

---

## Mécaniques clés

- Budgets identiques par duel
- Enchères secrètes avec tiebreaker par timestamp
- 5 positions basketball (position secondaire possible à efficacité réduite)
- 6 stats par personnage : Shoot, Dunk, Speed, Defense, Intelligence, Strength
- Bonus de synergie par univers
- Coût des personnages calculé dynamiquement

---

## Univers disponibles

| Univers       | Couleur associée |
|---------------|-----------------|
| NieR          | Bleu            |
| Final Fantasy | Violet          |
| Dragon Ball   | Orange          |
| Naruto        | (à définir)     |

---

## Schéma de base de données

```
users
characters          (nom, univers, position principale, position secondaire, stats x6, coût)
friendships         (user_id, friend_id, status)
duels               (challenger_id, opponent_id, status, budget)
draft_rounds        (duel_id, character_id, round_number)
bids                (draft_round_id, user_id, amount, submitted_at)
draft_results       (draft_round_id, winner_id, character_id)
matches             (duel_id, winner_id, status)
match_player_stats  (match_id, user_id, character_id, stats snapshot)
```

---

## Design system

- **Palette** : `#0b0e1a` (fond principal), `#111627`, `#161d30`
- **Accent** : `#f5d800` (jaune unique, aucun autre)
- **Typo** : Share Tech Mono (monospace, toutes les polices)
- **Border-radius** : 2px max
- **Pas de dégradés**
- **Pas d'ombres douces** — UI dure, pixel-like, dark

---

## Pages existantes (wireframes validés)

Landing, Login/Signup, Home, Roster, Character Detail, Draft, Draft Round Results, Matchmaking Modal, Match Results, Profile

---

## Conventions

- Modèles en anglais, snake_case
- Ne pas toucher au design system sans validation explicite
- Penser les features côté métier avant de coder