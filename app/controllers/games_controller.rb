class GamesController < ApplicationController

  def index
    @game_state = GameState.new
    @board_state = @game_state.get_game_state
    @current_player = @game_state.get_current_player

    @message = if winner = @game_state.winner?
                 "#{winner.to_s.upcase} won!"
               elsif @game_state.draw?
                 "Draw!"
               end
  end

  def reset
    GameState.new.reset
    redirect_to(root_path)
  end
end

