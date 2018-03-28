class ApiController < ActionController::API
  before_action :require_api_key

  def require_game
    render status: 400 unless current_game
  end

  def require_api_key
    render status: 401, json: {message: "Unauthorized"} if invalid_api_key?
  end

  def invalid_api_key?
    users = User.where(api_key: request.headers["X-API-KEY"])
    users.empty? || users.first.inactive?
  end

  def current_player
    case request.headers['X-API-KEY']
    when game.player_1 then Player.new(game.player_1_board)
    when game.player_2 then Player.new(game.player_2_board)
    end
  end

  def current_game
    game_id = params[:game_id] || params[:id]
    @game ||= Game.find(game_id) unless Game.where(id: game_id).empty?
  end
end
