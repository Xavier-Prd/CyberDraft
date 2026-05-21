class RosterController < ApplicationController
  def index
    # Cherche le duel le plus récent avec une draft en cours ou terminée
    @duel = current_user.duels
                        .where(status: [ "draft", "match", "finished" ])
                        .includes(:home_user, :away_user)
                        .order(updated_at: :desc)
                        .first

    if @duel
      @opponent = @duel.home_user == current_user ? @duel.away_user : @duel.home_user

      # Personnages remportés par le joueur dans ce duel
      my_results = DraftResult.joins(:draft_round)
                               .where(draft_rounds: { duel_id: @duel.id })
                               .where(winner_id: current_user.id)
                               .includes(:character)

      @my_characters = my_results.map(&:character).compact

      # Personnages remportés par l'adversaire
      opp_results = DraftResult.joins(:draft_round)
                                .where(draft_rounds: { duel_id: @duel.id })
                                .where.not(winner_id: current_user.id)
                                .includes(:character)
      @opponent_characters = opp_results.map(&:character).compact

      # Taux d'utilisation global pour chaque personnage (même calcul que characters#index)
      total_duels = Duel.where(status: [ "finished", "draft" ]).count
      usage_counts = DraftResult.group(:character_id).count
      @usage = {}
      usage_counts.each do |character_id, count|
        @usage[character_id] = total_duels > 0 ? ((count.to_f / total_duels) * 100).round : 0
      end

      # Filtre par univers si un paramètre ?universe= est passé dans l'URL
      if params[:universe].present?
        @my_characters = @my_characters.select { |c| c.universe == params[:universe] }
      end

      # Tri selon ?sort=
      @my_characters = case params[:sort]
                       when "cost"
                         @my_characters.sort_by { |c| -c.base_cost.to_i }
                       else
                         @my_characters.sort_by { |c| [ c.universe, c.name ] }
                       end

      # Liste des univers représentés dans le roster
      @universes = @my_characters.map(&:universe).uniq.sort

      # Synergies : regroupement par univers → bonus si 2+ persos du même univers
      @synergies = @my_characters.group_by(&:universe).map do |universe, chars|
        { universe: universe, count: chars.count, characters: chars }
      end.sort_by { |s| -s[:count] }
    else
      @my_characters = []
      @universes = []
      @synergies = []
    end
  end
end
