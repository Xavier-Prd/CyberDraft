class CharactersController < ApplicationController
  def index
    # Point de départ : tous les personnages
    characters = Character.all

    # Si l'URL contient ?universe=Naruto, on filtre par cet univers
    if params[:universe].present?
      characters = characters.where(universe: params[:universe])
    end

    # On calcule le taux d'utilisation de chaque personnage
    # C'est-à-dire : dans combien de duels ce personnage a-t-il été drafté ?
    total_duels = Duel.where(status: ["finished", "draft"]).count
    usage_counts = DraftResult.group(:character_id).count
    # usage_counts ressemble à : { 5 => 3, 12 => 1, ... }
    # clé = id du personnage, valeur = nombre de fois drafté

    @usage = {}
    usage_counts.each do |character_id, count|
      if total_duels > 0
        @usage[character_id] = ((count.to_f / total_duels) * 100).round
      else
        @usage[character_id] = 0
      end
    end

    # On trie selon le paramètre ?sort= dans l'URL
    if params[:sort] == "cost"
      @characters = characters.order(base_cost: :desc)
    elsif params[:sort] == "usage"
      # L'utilisation n'est pas en base de données donc on trie côté Ruby
      @characters = characters.to_a.sort_by { |character| -(@usage[character.id] || 0) }
    else
      # Tri par défaut : univers puis nom alphabétique
      @characters = characters.order(:universe, :name)
    end

    # Données pour l'en-tête : total de personnages et liste des univers
    @total_count = Character.count
    @universes = Character.distinct.pluck(:universe).sort
  end

  def show
    # Cherche le personnage par son id dans l'URL (/characters/5)
    # Lève une erreur 404 automatiquement si l'id n'existe pas
    @character = Character.find(params[:id])

    # Taux d'utilisation : combien de duels ont inclus ce personnage en draft
    total_duels = Duel.where(status: ["finished", "draft"]).count
    drafted_count = DraftResult.where(character_id: @character.id).count
    @usage = total_duels > 0 ? ((drafted_count.to_f / total_duels) * 100).round : 0

    # Somme de toutes les stats du personnage
    @total_stats = @character.speed + @character.shoot + @character.defense +
                   @character.strength + @character.dunk + @character.intelligence

    # Personnages du même univers — synergie potentielle en draft
    @same_universe = Character.where(universe: @character.universe)
                               .where.not(id: @character.id)
                               .limit(3)

    # Taux d'utilisation de ces personnages (pour afficher le % à côté)
    teammates_drafted = DraftResult.where(character_id: @same_universe.map(&:id)).group(:character_id).count
    @teammates_usage = {}
    teammates_drafted.each do |character_id, count|
      @teammates_usage[character_id] = total_duels > 0 ? ((count.to_f / total_duels) * 100).round : 0
    end

    # Taux de victoires avec ce personnage
    # On regarde si le joueur qui avait ce perso dans un match a gagné ce match
    total_appearances = MatchPlayerStat.joins(:match).where(character_id: @character.id).count
    winning_appearances = MatchPlayerStat.joins(:match)
                                         .where(character_id: @character.id)
                                         .where("matches.winner_id = match_player_stats.user_id")
                                         .count
    @win_rate = total_appearances > 0 ? ((winning_appearances.to_f / total_appearances) * 100).round : 0
  end
end
