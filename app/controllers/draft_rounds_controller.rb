class DraftRoundsController < ApplicationController
  before_action :set_draft_round

  def show
    @duel = @draft_round.duel

    # Vérifie que le joueur connecté appartient bien à ce duel
    unless @duel.home_user == current_user || @duel.away_user == current_user
      redirect_to duels_path, alert: "Tu n'as pas accès à ce draft round."
      return
    end

    @opponent = @duel.home_user == current_user ? @duel.away_user : @duel.home_user

    # Personnages déjà remportés dans CE duel (tous rounds confondus)
    # On les exclut du lot disponible car ils ne peuvent plus être enchéris
    won_character_ids = DraftResult.joins(:draft_round)
                                   .where(draft_rounds: { duel_id: @duel.id })
                                   .pluck(:character_id)

    # Personnages disponibles pour ce round (non encore draftés dans ce duel)
    @available_characters = Character.where.not(id: won_character_ids)
                                     .order(:universe, :name)

    # Enchères que le joueur a déjà posées pour ce round
    @my_bids = @draft_round.bids
                            .where(user_id: current_user.id)
                            .includes(:character)
                            .order(submitted_at: :desc)

    # Total engagé par le joueur dans ce round
    @engaged_this_round = @my_bids.sum(:amount)

    # Résultats si les deux joueurs ont validé → phase de révélation
    @results = @draft_round.draft_results.includes(:character, :winner)
    @is_revelation = @draft_round.both_validated?

    # Personnages remportés par le joueur dans ce duel (pour afficher le roster partiel)
    @my_draft_results = DraftResult.joins(:draft_round)
                                   .where(draft_rounds: { duel_id: @duel.id })
                                   .where(winner_id: current_user.id)
                                   .includes(:character)

    # Nombre de places déjà prises dans le roster
    @my_roster_count = @my_draft_results.count
  end

  def validate
    # Le joueur valide ses enchères pour ce round
    # On enregistre le timestamp de validation selon son rôle (home ou away)
    if @draft_round.duel.home_user == current_user
      @draft_round.update(home_validate_at: Time.current)
    else
      @draft_round.update(away_validate_at: Time.current)
    end

    redirect_to draft_round_path(@draft_round), notice: "Tes offres ont été scellées."
  end

  private

  def set_draft_round
    @draft_round = DraftRound.find(params[:id])
  end
end
