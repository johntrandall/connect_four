class ChitsController < ApplicationController

  def create
    column = params[:column_num]

    # puts game_state
    raise if game_state.nil?

    modify_game_state(game_state, column, current_player)

    flip_player(current_player)

    redirect_back(fallback_location: root_path)
  end

  def modify_game_state(game_state, column_num, current_player)
    deepest_nil_row = nil
    game_state.each_with_index do |row, i|
      if row[column_num].nil?
        deepest_nil_row = i
      end

      #drop it in
      game_state[deepest_nil_row][column_num] = current_player
    end
  end

  def new_game_state
    [
      [nil, nil, nil, nil, :red, :black],
      [nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil]
    ]
  end

  private

  def game_state
    game_state = cookies[:game_state] || new_game_state
  end

  def current_player
    current_player = cookies[:player] || :red
  end

  def flip_player(current_player)
    if current_player == :red
      current_player = :black
    else
      current_player = :red
    end
  end

end
