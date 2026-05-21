class LeaderboardController < ApplicationController
  def index
    # On récupère tous les users et on calcule leurs stats
    all_users = User.all

    # Pour chaque user : nombre de victoires, défaites, total matchs joués
    @standings = all_users.map do |user|
      wins = user.won_matches.count

      # Total matchs joués (avec un gagnant désigné, donc terminés)
      total = Match.joins(:duel)
                   .where("duels.home_user_id = ? OR duels.away_user_id = ?", user.id, user.id)
                   .where.not(winner_id: nil)
                   .count

      losses = total - wins

      # Score diff : somme des (home_score - away_score) ou (away_score - home_score)
      # selon le côté du joueur dans chaque match
      diff = 0
      Match.joins(:duel)
           .where("duels.home_user_id = ? OR duels.away_user_id = ?", user.id, user.id)
           .where.not(winner_id: nil)
           .includes(:duel)
           .each do |match|
        if match.duel.home_user_id == user.id
          diff += (match.home_score.to_i - match.away_score.to_i)
        else
          diff += (match.away_score.to_i - match.home_score.to_i)
        end
      end

      # Forme : résultats des 5 derniers matchs (V ou D)
      recent_matches = Match.joins(:duel)
                             .where("duels.home_user_id = ? OR duels.away_user_id = ?", user.id, user.id)
                             .where.not(winner_id: nil)
                             .order(played_at: :desc, created_at: :desc)
                             .limit(5)
      form = recent_matches.map { |m| m.winner_id == user.id ? "V" : "D" }

      {
        user:   user,
        wins:   wins,
        losses: losses,
        total:  total,
        points: wins * 2, # 2 points par victoire, comme en ligue
        diff:   diff,
        form:   form
      }
    end

    # Tri : d'abord par points décroissants, puis diff décroissante
    @standings = @standings.sort_by { |s| [-s[:points], -s[:diff]] }

    # On note le rang du joueur connecté pour le mettre en évidence
    @my_rank = @standings.index { |s| s[:user] == current_user }
  end
end
