class AddStatusToFriendships < ActiveRecord::Migration[8.1]
  def change
    add_column :friendships, :status, :string
  end
end
