class Match < ApplicationRecord
  belongs_to :duel
  belongs_to :winner, class_name: "User", optional: true
end
