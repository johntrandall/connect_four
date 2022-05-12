class GameController < ApplicationController

  def index
    if winner = check_for_win_condition(game_state)
      render "win screen", partial: winner
      return
    end

    if check_for_draw_condition(game_state)
      render "draw screen"
      return
    end

    @game_state = JSON.parse(cookies[:game_state])
    if @game_state.nil?
      cookies[:game_state] = new_game_state
    end
    @game_state = JSON.parse(cookies[:game_state])

    puts cookies[:game_state]
  end

  def new_game_state
    [
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, :red, :black]
    ].to_json
  end

  def current_player
    current_player = cookies[:player] || :red
  end

  def game_state
    game_state = cookies[:game_state] || new_game_state
  end

  def check_for_win_condition
    if check_for_horizontal_win
      return check_for_horizontal_win
    end
    if check_for_vertical_win
      return check_for_vertical_win
    end
    if check_for_diagonal_win
      return check_for_diagonal_win
    end
  end

  def check_for_horizontal_win
    game_state.each do |row|
      return :black if win_row?(row, :black)
      return :red if win_row?(row, :red)
    end
  end

  def win_row(row, color)
    counter = 0
    row.each do |slot|
      if slot == color
        counter+=1
      else
        counter = 0
      end
    end
    return color if counter >= 4
  end

  def check_for_vertical_win
    game_state.transpose.each do |row|
      return :black if win_row?(row, :black)
      return :red if win_row?(row, :red)
    end
  end

  def check_for_diagonal_win
    # game_state
  end

  def check_for_draw_condition
    return false if @game_state.flatten.include?(0)
    return true
  end

end

