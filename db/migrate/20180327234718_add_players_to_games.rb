class AddPlayersToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :player_1, :string
    add_column :games, :player_2, :string
  end
end
