class MatchesController < ApplicationController
  def index
    # Récupère tous les matchs impliquant le joueur connecté
    # incluant les associations pour éviter les N+1
    all_matches = Match.joins(:duel)
                       .where("duels.home_user_id = ? OR duels.away_user_id = ?",
                              current_user.id, current_user.id)
                       .includes(duel: [ :home_user, :away_user ])
                       .order("matches.played_at DESC NULLS LAST, matches.created_at DESC")

    # On regroupe les matchs par date (played_at si disponible, sinon created_at)
    # Cela crée un Hash { Date => [Match, Match, ...] }
    @matches_by_date = all_matches.group_by do |match|
      match.played_at&.to_date || match.created_at.to_date
    end
  end

  def show
    # Récupère le match avec toutes ses associations en une seule requête
    @match = Match.includes(
      duel: [ :home_user, :away_user ],
      match_player_stats: :character
    ).find(params[:id])

    @duel = @match.duel
    @home_user = @duel.home_user
    @away_user = @duel.away_user

    # Stats des personnages de chaque équipe, triées par points décroissants
    @home_stats = @match.match_player_stats
                        .where(user_id: @home_user.id)
                        .includes(:character)
                        .sort_by { |s| -(s.points || 0) }

    @away_stats = @match.match_player_stats
                        .where(user_id: @away_user.id)
                        .includes(:character)
                        .sort_by { |s| -(s.points || 0) }

    # True si le joueur connecté a gagné ce match
    @user_won = @match.winner == current_user

    # Trouve le MVP : le joueur avec le plus de points toutes équipes confondues
    all_stats = @home_stats + @away_stats
    @mvp_stat = all_stats.max_by { |s| s.points.to_i }
  end
end
