module Api
  module V1
    class GamesController < ActionController::API
      def show
        game = Game.find(params[:id])
        render json: game
      end

      def create
        player_1_board = Board.new
        player_2_board = Board.new
        game_attributes = {
          player_1_board: player_1_board,
          player_2_board: player_2_board
        }
        game = Game.create(game_attributes)

        render json: game
      end
    end
  end
end
