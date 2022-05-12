class GameController < ApplicationController

  def index
    if winner = GameState.check_for_win_condition
      @message = "#{winner.to_s.upcase} won!"
      return
    end

    if GameState.check_for_draw_condition
      @message = "Draw!"
      return
    end
  end
end

