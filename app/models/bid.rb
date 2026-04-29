class Bid < ApplicationRecord
  belongs_to :draft_round
  belongs_to :user
  belongs_to :character
end
