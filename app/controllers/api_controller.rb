class ApiController < ActionController::API
  before_action :require_api_key

  def require_game
    game_id = params[:game_id] || params[:id]
    render status: 400 if Game.where(id: game_id).empty?
  end

  def require_api_key
    render status: 401, json: {message: "Unauthorized"} if invalid_api_key?
  end

  def invalid_api_key?
    users = User.where(api_key: request.headers["X-API-KEY"])
    users.empty? || users.first.inactive?
  end
end
