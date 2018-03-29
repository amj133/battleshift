class Api::V1::Games::ShipsController < ApiController
  def create
    ship = Ship.new(params[:ship_size].to_i)
    board = case request.headers['X-API-KEY']
            when current_game.player_1.api_key then current_game.player_1.board
            when current_game.player_2.api_key then current_game.player_2.board
            end
    ship_placer = ShipPlacer.new({
                    board: board,
                    ship: ship,
                    start_space: params[:start_space],
                    end_space: params[:end_space]
                    })
    ship_placer.run
    current_game.save
    render json: current_game, message: ship_placer.message
  end
end
