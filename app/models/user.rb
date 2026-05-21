class User < ApplicationRecord
  # Devise gère l'authentification — chaque module ajoute un comportement :
  # database_authenticatable → vérifie email + mot de passe à la connexion
  # registerable            → permet la création de compte
  # recoverable             → permet la réinitialisation du mot de passe
  # rememberable            → gère le "se souvenir de moi"
  # validatable             → valide automatiquement email (présence + unicité) et mot de passe (longueur min)
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validation du username : obligatoire, unique, 2-20 caractères, lettres/chiffres/tirets bas uniquement
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 2, maximum: 20 },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "lettres, chiffres et _ uniquement" }

  # Nom affiché dans les vues (à utiliser partout à la place de email.split('@').first)
  def display_name
    username.presence || email.split("@").first
  end

  # Initiales pour les avatars (2 premiers caractères)
  def initials
    display_name.first(2).upcase
  end

  # Amitiés envoyées par ce user (il est le sender)
  # foreign_key: "sender_id" car la colonne ne s'appelle pas user_id
  # dependent: :destroy → si le user est supprimé, ses demandes envoyées le sont aussi
  has_many :sent_friendships, class_name: "Friendship", foreign_key: "sender_id", dependent: :destroy

  # Amitiés reçues par ce user (il est le receiver)
  has_many :received_friendships, class_name: "Friendship", foreign_key: "receiver_id", dependent: :destroy

  # Duels où ce user est l'hôte (celui qui a envoyé le défi)
  has_many :home_duels, class_name: "Duel", foreign_key: "home_user_id", dependent: :destroy

  # Duels où ce user est le challenger (celui qui a reçu le défi)
  has_many :away_duels, class_name: "Duel", foreign_key: "away_user_id", dependent: :destroy

  # Matchs remportés par ce user — pas de dependent: :destroy car le match doit rester même si le winner est supprimé
  has_many :won_matches, class_name: "Match", foreign_key: "winner_id"

  # Toutes les mises placées par ce user pendant les drafts
  has_many :bids, dependent: :destroy

  # Retourne tous les duels du user, qu'il soit home ou away
  # .or() permet de combiner deux conditions avec un OR en SQL
  def duels
    Duel.where(home_user: self).or(Duel.where(away_user: self))
  end

  # Retourne les IDs de tous les amis confirmés (status: "accepted") dans les deux sens
  # .pluck(:receiver_id) récupère uniquement les IDs sans charger les objets en mémoire (plus rapide)
  def accepted_friend_ids
    sent = sent_friendships.where(status: "accepted").pluck(:receiver_id)
    received = received_friendships.where(status: "accepted").pluck(:sender_id)
    # On fusionne les deux tableaux avec + pour avoir tous les amis
    sent + received
  end
end
