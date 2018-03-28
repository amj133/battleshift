class Api::V1::GamesController < ApiController
  before_action :require_game, only: [:show]

  def show
    render json: Game.find(params[:id])
  end

  def create
    player_1_board = Board.new
    player_2_board = Board.new
    game_attributes = {
      player_1_board: player_1_board,
      player_2_board: player_2_board,
      player_1: request.headers['X-API-KEY'],
      player_2: User.find_by(email: params[:opponent_email]).api_key
    }
    game = Game.create(game_attributes)

    render json: game
  end
end
