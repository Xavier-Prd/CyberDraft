# 🏀 Cyber Draft

**Cyber Draft** is a fantasy basketball game where you draft legendary characters from different anime and video game universes (NieR: Automata, Final Fantasy, Dragon Ball, Naruto...) and compete against other players.

Built with **Ruby on Rails** and **PostgreSQL**.

---

## ✨ Features

- **Blind auction draft system** — both players secretly bid on characters each round; the highest bidder wins the character, losers get their bid refunded
- **Tie-breaking by timestamp** — if two players bid the same amount, the one who submitted first wins
- **5 positions** — Meneur, Arrière, Ailier, Ailier Fort, Pivot — each position affects matchups and performance
- **Recommended positions** — each character has a recommended position based on their dominant stat; playing them out of position reduces effectiveness
- **Universe bonuses** — align 2 or 3 characters from the same universe for stat bonuses
- **Match simulation** — matches are simulated automatically after the draft with a full narrative breakdown quarter by quarter
- **Position matchups** — each position faces the opposing team's same position; stats determine who dominates
- **Matchmaking** — challenge a friend directly or get matched automatically with any available player
- **Friends system** — add friends, see their ranking on your home page
- **Leaderboard** — global ranking and friends-only ranking

---

## 🎮 How it works

1. **Challenge a friend** or use **matchmaking** to find an opponent
2. **Draft phase** — both players have the same starting budget and secretly bid on available characters each round
3. To validate a round, each player must have bid on at least **5 characters** covering **all 5 positions**
4. After all rounds, the **match is simulated** automatically
5. Results include full stats per player (points, rebounds, interceptions, assists) and a narrative summary

---

## 🤖 Characters & Stats

Each character has 6 stats:

| Stat | Position | Role |
|------|----------|------|
| **Shoot** | Arrière | 3-point shots |
| **Dunk** | Ailier Fort | Dunks, offensive rebounds |
| **Speed** | Ailier | Drives, lay-ups |
| **Defense** | Pivot | Blocks, defensive rebounds |
| **Intelligence** | Meneur | Assists, interceptions |
| **Strength** | Pivot | Paint dominance |

The **base cost** of a character is calculated automatically from their total stats — no fixed price stored in the database.

---

## 🗄️ Database Schema

| Table | Description |
|-------|-------------|
| `users` | Players (Devise auth) |
| `characters` | Available characters (seed data) |
| `friendships` | Friend relationships between users |
| `duels` | A duel between two players |
| `draft_rounds` | Each bidding round within a duel |
| `bids` | A player's secret bid on a character |
| `draft_results` | Result per character per round |
| `matches` | Final match result with narrative |
| `match_player_stats` | Individual stats per character per match |

---

## 🛠️ Tech Stack

- **Ruby on Rails 7**
- **PostgreSQL**
- **Devise** — authentication
- **Stimulus** — JavaScript controllers
- **Hotwire / Turbo** — dynamic UI updates
- **Faker** — seed data
- **Bullet** — N+1 query detection
- **Brakeman** — security analysis

---

## 🚀 Getting started

### Prerequisites

- Ruby 3.x
- PostgreSQL
- Node.js & Yarn

### Installation

```bash
git clone https://github.com/your-username/cyber_draft.git
cd cyber_draft
bundle install
yarn install
```

### Database setup

```bash
cp .env.example .env
# Fill in your database credentials in .env

rails db:create
rails db:migrate
rails db:seed
```

### Run the app

```bash
./bin/dev
```

Visit `http://localhost:3000`

---

## 🌱 Seed data

The seeds populate the database with:
- Characters from NieR: Automata, Final Fantasy, Dragon Ball, Naruto and more
- Test users with existing friendships and match history

---

## 📁 Project structure

```
app/
├── controllers/
│   ├── home_controller.rb
│   ├── characters_controller.rb
│   ├── duels_controller.rb
│   ├── draft_rounds_controller.rb
│   ├── friendships_controller.rb
│   ├── matches_controller.rb
│   └── users_controller.rb
├── models/
│   ├── user.rb
│   ├── character.rb
│   ├── friendship.rb
│   ├── duel.rb
│   ├── draft_round.rb
│   ├── bid.rb
│   ├── draft_result.rb
│   ├── match.rb
│   └── match_player_stat.rb
├── services/
│   ├── matchmaking_service.rb
│   ├── bid_validator_service.rb
│   ├── draft_round_resolver_service.rb
│   ├── universe_bonus_calculator.rb
│   ├── match_simulator_service.rb
│   └── narrative_generator_service.rb
└── javascript/
    └── controllers/
        ├── bid_form_controller.js
        ├── draft_tabs_controller.js
        ├── match_tabs_controller.js
        └── matchmaking_modal_controller.js
```

---

## 🔒 Environment variables

Create a `.env` file at the root of the project:

```
DATABASE_URL=postgresql://localhost/cyber_draft_development
```

---

## 🚢 Deployment

The app is deployed on **Heroku**.

```bash
git push heroku main
heroku run rails db:migrate
heroku run rails db:seed
```

---

## 👤 Author

**Xavier** — Junior Fullstack Developer
[GitHub](https://github.com/your-username) · [Portfolio](https://pardoue.me)

---

## 📄 License

This project is for portfolio and learning purposes.
Character names and universes belong to their respective owners.
