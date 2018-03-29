class TurnProcessor
  attr_reader :status

  def initialize(game, target, opponent_board, current_player)
    @game   = game
    @target = target
    @messages = []
    @opponent_board = opponent_board
    @player = current_player
    @status = 200
  end

  def run!
    begin
      attack_opponent
      @messages << "Game over." if game_over?
      game.save!
    rescue InvalidAttack => e
      @messages << e.message
      @status = 400
    end
  end

  def message
    @messages.join(" ")
  end

  def game_over?
    opponent_board.board.flatten.all? do |space|
      space.values.first.contents.nil? || space.values.first.contents.is_sunk?
    end
  end

  private

  attr_reader :game, :target, :opponent_board, :player

  def attack_opponent
    result = Shooter.fire!(board: opponent_board, target: target)
    @messages << "Your shot resulted in a #{result}."
    switch_turns
  end

  def switch_turns
    player.turns += 1
    game.current_turn = game.player_1.turns - game.player_2.turns
    game.save!
  end

  # def ai_attack_back
  #   result = AiSpaceSelector.new(player.board).fire!
  #   @messages << "The computer's shot resulted in a #{result}."
  #   game.player_2_turns += 1
  # end

  # def player
  #   Player.new(game.player_1_board)
  # end
  #
  # def opponent
  #   Player.new(game.player_2_board)
  # end

end
