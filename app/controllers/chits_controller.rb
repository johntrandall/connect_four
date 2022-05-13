class ChitsController < ApplicationController

  def create
    column = params[:column_num].to_i

    GameState.modify_board_state(column)

    GameState.flip_player

    redirect_back(fallback_location: root_path)
  end





end
