class MatchPlayerStat < ApplicationRecord
  belongs_to :match
  belongs_to :character
  belongs_to :user
end
