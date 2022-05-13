class GamesController < ApplicationController

  def index
    @game_state = GameState.new
    @board_state = @game_state.board_state
    @current_player = @game_state.current_player

    winner = @game_state.winner?
    draw = @game_state.draw?

    @show_buttons = true unless (winner || draw)

    @message = if winner
                 "#{winner.to_s.upcase} won!"
               elsif draw
                 "Draw!"
               end
  end

  def reset
    GameState.new.reset
    redirect_to(root_path)
  end
end

