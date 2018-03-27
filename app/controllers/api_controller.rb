class ApiController < ActionController::API
  before_action :require_api_key

  def require_game
    render status: 400 if Game.where(id: params[:id]).empty?
  end

  def require_api_key
    render status: 401, json: {message: "Unauthorized"} unless valid_api_key?
  end

  def valid_api_key?
    users = User.where(api_key: request.headers["X-API-KEY"])
    users.first && users.first.active?
  end
end
