class PagesController < ApplicationController
  # La page d'accueil est accessible sans être connecté (landing page)
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    # Si le visiteur n'est pas connecté, on affiche juste la landing page
    return unless user_signed_in?

    # --- Duels en cours (draft ou match en simulation) ---
    # On récupère les duels où le user est home OU away, avec un statut actif
    @active_duels = current_user.duels
                                .where(status: [ "draft", "match" ])
                                .includes(:home_user, :away_user)

    # --- Invitations reçues en attente de réponse ---
    # Le user est away_user et n'a pas encore accepté/refusé
    @pending_invitations = Duel.where(away_user: current_user, status: "pending")
                               .includes(:home_user)

    # --- 3 derniers duels terminés pour l'historique ---
    @finished_duels = current_user.duels
                                  .where(status: "finished")
                                  .includes({ match: :winner }, :home_user, :away_user)
                                  .order(updated_at: :desc)
                                  .limit(3)

    # --- Stats victoires / défaites ---
    @wins = current_user.won_matches.count
    # Total de matchs joués (avec un gagnant désigné)
    @total_played = Match.joins(:duel)
                         .where("duels.home_user_id = ? OR duels.away_user_id = ?",
                                current_user.id, current_user.id)
                         .where.not(winner_id: nil)
                         .count
    @losses = @total_played - @wins

    # --- Top 3 personnages les plus draftés par ce user ---
    # On cherche les DraftResults gagnés par le user, groupés par personnage
    draft_counts = DraftResult.joins(draft_round: :duel)
                               .where(winner_id: current_user.id)
                               .group(:character_id)
                               .order("count_all DESC")
                               .count
                               .first(3)

    # On charge les personnages en une seule requête pour éviter le N+1
    char_ids = draft_counts.map(&:first)
    chars_by_id = Character.where(id: char_ids).index_by(&:id)

    # On construit un tableau de hashes { character:, count: }
    @top_characters = draft_counts.filter_map do |char_id, count|
      char = chars_by_id[char_id]
      { character: char, count: count } if char
    end
  end
end
