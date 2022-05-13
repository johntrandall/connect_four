class GameController < ApplicationController

  def index
    @game_state = GameState.get_game_state
    @current_player = GameState.get_current_player

    @message = if winner = GameState.winner?
                 "#{winner.to_s.upcase} won!"
               elsif GameState.draw?
                 "Draw!"
               end
  end
end

