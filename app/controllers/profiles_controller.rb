class ProfilesController < ApplicationController
  def show
    # Stats globales victoires / défaites
    @wins = current_user.won_matches.count
    @total_played = Match.joins(:duel)
                         .where("duels.home_user_id = ? OR duels.away_user_id = ?",
                                current_user.id, current_user.id)
                         .where.not(winner_id: nil)
                         .count
    @losses = @total_played - @wins

    # Ratio en pourcentage (0 si aucun match joué)
    @win_rate = @total_played > 0 ? ((@wins.to_f / @total_played) * 100).round : 0

    # Nombre de duels joués (statut finished)
    @total_duels = current_user.duels.where(status: "finished").count

    # Nombre de personnages draftés (gagnés aux enchères toutes saisons confondues)
    @total_drafts = DraftResult.joins(draft_round: :duel)
                               .where(winner_id: current_user.id)
                               .count

    # Taux de draft réussi : parmi les rounds où le joueur a enchéri, combien il a gagnés
    total_bids_placed = Bid.where(user_id: current_user.id).count
    @draft_success_rate = total_bids_placed > 0 ? ((@total_drafts.to_f / total_bids_placed) * 100).round : 0

    # Top 3 personnages emblématiques (les plus souvent draftés)
    draft_counts = DraftResult.joins(draft_round: :duel)
                               .where(winner_id: current_user.id)
                               .group(:character_id)
                               .order("count_all DESC")
                               .count
                               .first(3)

    char_ids = draft_counts.map(&:first)
    chars_by_id = Character.where(id: char_ids).index_by(&:id)
    @top_characters = draft_counts.filter_map do |char_id, count|
      char = chars_by_id[char_id]
      { character: char, count: count } if char
    end

    # Rivaux : adversaires affrontés le plus souvent dans les duels terminés
    finished_duels = current_user.duels.where(status: "finished").includes(:home_user, :away_user, match: [])
    rival_stats = Hash.new { |h, k| h[k] = { wins: 0, losses: 0 } }

    finished_duels.each do |duel|
      opponent = duel.home_user == current_user ? duel.away_user : duel.home_user
      if duel.match&.winner == current_user
        rival_stats[opponent][:wins] += 1
      elsif duel.match
        rival_stats[opponent][:losses] += 1
      end
    end

    # Top 3 adversaires les plus affrontés
    @rivals = rival_stats.map do |user, stats|
      { user: user, wins: stats[:wins], losses: stats[:losses], total: stats[:wins] + stats[:losses] }
    end.sort_by { |r| -r[:total] }.first(3)
  end
end
