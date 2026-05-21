class DuelsController < ApplicationController
  before_action :set_duel, only: [ :show, :accept, :decline ]

  # ----------------------------------------------------------------
  # INDEX — liste tous les duels du joueur connecté
  # ----------------------------------------------------------------
  def index
    # Invitations reçues non encore traitées (le user est away_user)
    @pending_received = Duel.where(away_user: current_user, status: "pending")
                            .includes(:home_user)
                            .order(created_at: :desc)

    # Défis envoyés non encore acceptés (le user est home_user)
    @pending_sent = Duel.where(home_user: current_user, status: "pending")
                        .includes(:away_user)
                        .order(created_at: :desc)

    # Duels en cours (phase de draft ou match en simulation)
    @active_duels = current_user.duels
                                .where(status: [ "draft", "match" ])
                                .includes(:home_user, :away_user)
                                .order(updated_at: :desc)

    # Historique des duels terminés ou refusés (10 derniers)
    @history = current_user.duels
                           .where(status: [ "finished", "declined" ])
                           .includes(:home_user, :away_user, match: :winner)
                           .order(updated_at: :desc)
                           .limit(10)

    # Adversaires disponibles = users sans duel actif avec le joueur connecté
    busy_user_ids = current_user.duels
                                .where(status: [ "pending", "draft", "match" ])
                                .pluck(:home_user_id, :away_user_id)
                                .flatten
                                .uniq
    @available_opponents = User.where.not(id: busy_user_ids).order(:email)
  end

  # ----------------------------------------------------------------
  # SHOW — détail d'un duel (rounds, résultats, actions disponibles)
  # ----------------------------------------------------------------
  def show
    # Tous les rounds avec leurs bids et résultats en une requête
    @draft_rounds = @duel.draft_rounds
                         .includes(draft_results: [ :character, :winner ], bids: :character)
                         .order(:round_number)

    # Round actuel = premier round non encore validé par les deux joueurs
    @current_round = @draft_rounds.find { |r| !r.both_validated? }

    # Personnages remportés par chaque joueur dans ce duel
    my_results = DraftResult.joins(:draft_round)
                             .where(draft_rounds: { duel_id: @duel.id })
                             .where(winner_id: current_user.id)
                             .includes(:character)

    opp_results = DraftResult.joins(:draft_round)
                              .where(draft_rounds: { duel_id: @duel.id })
                              .where.not(winner_id: current_user.id)
                              .includes(:character)

    @my_characters    = my_results.map(&:character).compact
    @opponent_characters = opp_results.map(&:character).compact

    # Match si le duel est terminé
    @match = @duel.match
  end

  # ----------------------------------------------------------------
  # CREATE — envoie un nouveau défi à un adversaire
  # ----------------------------------------------------------------
  def create
    opponent = User.find_by(id: duel_params[:away_user_id])

    unless opponent
      redirect_to duels_path, alert: "Adversaire introuvable."
      return
    end

    @duel = Duel.new(
      home_user: current_user,
      away_user: opponent,
      budget:    duel_params[:budget],
      origin:    "challenge",
      status:    "pending"
    )

    if @duel.save
      redirect_to duel_path(@duel), notice: "Défi envoyé à #{opponent.email.split('@').first} !"
    else
      redirect_to duels_path, alert: @duel.errors.full_messages.join(", ")
    end
  end

  # ----------------------------------------------------------------
  # ACCEPT — l'away_user accepte → change statut + crée le round 1
  # ----------------------------------------------------------------
  def accept
    unless @duel.away_user == current_user
      redirect_to duels_path, alert: "Tu ne peux pas accepter ce défi."
      return
    end

    unless @duel.pending?
      redirect_to duel_path(@duel), alert: "Ce défi ne peut plus être accepté."
      return
    end

    # Passe en mode draft et crée le premier round de draft
    @duel.update!(status: "draft", current_round: 1)
    DraftRound.create!(duel: @duel, round_number: 1)

    redirect_to duel_path(@duel), notice: "Défi accepté ! La draft commence."
  end

  # ----------------------------------------------------------------
  # DECLINE — l'away_user refuse le défi
  # ----------------------------------------------------------------
  def decline
    unless @duel.away_user == current_user
      redirect_to duels_path, alert: "Tu ne peux pas refuser ce défi."
      return
    end

    unless @duel.pending?
      redirect_to duel_path(@duel), alert: "Ce défi ne peut plus être refusé."
      return
    end

    @duel.update!(status: "declined")
    redirect_to duels_path, notice: "Défi refusé."
  end

  private

  def set_duel
    @duel = Duel.includes(:home_user, :away_user).find(params[:id])
    @opponent = @duel.home_user == current_user ? @duel.away_user : @duel.home_user

    unless @duel.home_user == current_user || @duel.away_user == current_user
      redirect_to duels_path, alert: "Tu n'as pas accès à ce duel."
    end
  end

  def duel_params
    params.require(:duel).permit(:away_user_id, :budget)
  end
end
