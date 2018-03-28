class Api::V1::Games::ShotsController < ApiController
  before_action :require_game

  def create
    game = Game.find(params[:game_id])

    opponent_board = case request.headers['X-API-KEY']
                     when game.player_1 then game.player_2_board
                     when game.player_2 then game.player_1_board
                     end

    turn_processor = TurnProcessor.new(game, params[:shot][:target], opponent_board)

    turn_processor.run!
    render json: game, message: turn_processor.message
  end
end
