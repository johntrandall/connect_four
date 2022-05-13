class GameController < ApplicationController

  def index
    if winner = GameState.winner?
      @message = "#{winner.to_s.upcase} won!"
      return
    end

    if GameState.draw?
      @message = "Draw!"
      return
    end
  end
end

