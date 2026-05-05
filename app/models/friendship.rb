class Friendship < ApplicationRecord
  # Un friendship a deux participants :
  # - sender  : celui qui envoie la demande
  # - receiver: celui qui la reçoit
  # "class_name: User" précise que les deux colonnes (sender_id / receiver_id)
  # pointent vers la table users, pas vers une table "senders" ou "receivers"
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  # Enum = liste fermée de valeurs autorisées pour le champ "status"
  # "pending"  → demande envoyée, pas encore traitée
  # "accepted" → demande acceptée, ils sont amis
  # default: "pending" → quand on crée un Friendship sans préciser le status, il vaut "pending" automatiquement
  # Cela génère aussi des méthodes pratiques : friendship.pending? / friendship.accepted? / friendship.accepted!
  enum :status, { pending: "pending", accepted: "accepted" }, default: "pending"

  # Empêche d'envoyer deux demandes au même joueur dans le même sens (A → B deux fois)
  # scope: :sender_id signifie "unicité de receiver_id POUR UN sender_id donné"
  validates :receiver_id, uniqueness: { scope: :sender_id, message: "demande déjà envoyée à ce joueur" }

  # Appelle nos méthodes de validation personnalisées ci-dessous
  validate :no_self_friendship
  validate :no_reverse_friendship

  private

  # Empêche un user de s'envoyer une demande à lui-même (A → A)
  def no_self_friendship
    errors.add(:receiver_id, "ne peut pas être vous-même") if sender_id == receiver_id
  end

  # Empêche d'envoyer une demande si une demande dans l'autre sens existe déjà (A → B bloqué si B → A existe)
  def no_reverse_friendship
    # "return unless" = on sort de la méthode si la condition est fausse (rien à faire)
    # Si la condition est vraie (la demande inverse existe), on ajoute une erreur
    return unless Friendship.where(sender_id: receiver_id, receiver_id: sender_id).exists?

    errors.add(:base, "une demande existe déjà entre ces deux joueurs")
  end
end
