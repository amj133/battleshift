class Api::V1::Games::ShipsController < ApiController
  def create
    game = Game.find(params[:game_id])
    ship = Ship.new(params[:ship_size].to_i)
    # current_board = current_player.board
    board = case request.headers['X-API-KEY']
            when game.player_1 then game.player_1_board
            when game.player_2 then game.player_2_board
            end
    ship_placer = ShipPlacer.new({
                    board: board,
                    ship: ship,
                    start_space: params[:start_space],
                    end_space: params[:end_space]
                    })
    ship_placer.run
    game.save
    render json: game, message: ship_placer.message
  end
end
