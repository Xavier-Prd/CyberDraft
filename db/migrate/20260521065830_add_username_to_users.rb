class AddUsernameToUsers < ActiveRecord::Migration[8.1]
  def up
    add_column :users, :username, :string, null: false, default: ""
    # Initialise les users existants avec le préfixe de leur email
    User.find_each { |u| u.update_columns(username: u.email.split("@").first) }
    add_index :users, :username, unique: true
  end

  def down
    remove_column :users, :username
  end
end
