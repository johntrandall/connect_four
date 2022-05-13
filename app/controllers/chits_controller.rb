class ChitsController < ApplicationController

  def create
    column = params[:column_num].to_i

    game_state = GameState.new
    game_state.modify_board_state(column)

    game_state.flip_player

    redirect_back(fallback_location: root_path)
  end





end
