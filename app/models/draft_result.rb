class DraftResult < ApplicationRecord
  belongs_to :draft_round
  belongs_to :character
  belongs_to :winner, class_name: "User"
end
