class GameState

  STARTING_GAME_STATE = [
    [nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil]
  ]

  STARTING_PLAYER = :red

  def reset
    Rails.cache.write(:current_player, STARTING_PLAYER)
    Rails.cache.write(:get_game_state, STARTING_GAME_STATE)
  end

  def get_game_state
    Rails.cache.fetch (:get_game_state) do
      STARTING_GAME_STATE
    end
  end

  def get_current_player
    Rails.cache.fetch (:current_player) do
      STARTING_PLAYER
    end
  end

  def modify_board_state(column_num)
    deepest_nil_row = nil
    get_game_state.each_with_index do |row, i|
      if row[column_num].nil?
        deepest_nil_row = i
      end
    end
    patch_game_state(deepest_nil_row, column_num, get_current_player)
  end

  def flip_player
    if get_current_player == :red
      set_current_player(:black)
      return :black
    end
    if get_current_player == :black
      set_current_player(:red)
      return :red
    end
  end

  def winner?
    game_state = get_game_state
    horizontal_winner(game_state) || vertical_winner(game_state) || diagonal_winner(game_state)
  end

  def draw?
    game_state = get_game_state
    return false if game_state.flatten.include?(nil)
    return true
  end

  def column_full?(col_num)
    game_state = get_game_state
    return game_state.all? do |row|
      row[col_num].present?
    end
  end

  private

  def set_current_player(value)
    Rails.cache.write(:current_player, value)
    value
  end

  def patch_game_state(row_num, col_num, current_player)
    gs_nested_array = get_game_state
    gs_nested_array[row_num][col_num] = current_player
    Rails.cache.write(:get_game_state, gs_nested_array)
  end

  def horizontal_winner(game_state)
    game_state.each do |row|
      return :black if winner_on_row?(row, :black)
      return :red if winner_on_row?(row, :red)
    end
    nil
  end

  def vertical_winner(game_state)
    game_state.transpose.each do |row|
      return :black if winner_on_row?(row, :black)
      return :red if winner_on_row?(row, :red)
    end
    nil
  end

  def winner_on_row?(row, color)
    counter = 0
    row.each do |slot|
      if slot == color
        counter += 1
      else
        counter = 0
      end
      return color if counter >= 4
    end
    nil
  end

  def diagonal_winner(game_state)
    down_right_diagonal_win_start_points = [
      [0, 0],
      [0, 1],
      [0, 2],
      [0, 3],
      [1, 0],
      [1, 1],
      [1, 2],
      [1, 3],
      [2, 0],
      [2, 1],
      [2, 2],
      [2, 3],
    ]
    up_right_diagonal_win_start_points = [
      [3, 0],
      [3, 1],
      [3, 2],
      [3, 3],
      [4, 0],
      [4, 1],
      [4, 2],
      [4, 3],
      [5, 0],
      [5, 1],
      [5, 2],
      [5, 3],
    ]
    down_right_diagonal_win_start_points.each do |coordinates|
      x = coordinates[0]
      y = coordinates[1]
      return :black if win_down_right_from_here?(x, y, :black, game_state)
      return :red if win_down_right_from_here?(x, y, :red, game_state)
    end
    up_right_diagonal_win_start_points.each do |coordinates|
      x = coordinates[0]
      y = coordinates[1]
      return :black if win_up_right_from_here?(x, y, :black, game_state)
      return :red if win_up_right_from_here?(x, y, :red, game_state)
    end
    nil
  end

  def win_down_right_from_here?(x, y, color, game_state)
    if game_state[x][y] == color &&
      game_state[x + 1][y + 1] == color &&
      game_state[x + 2][y + 2] == color &&
      game_state[x + 3][y + 3] == color
      return true
    end
  end

  def win_up_right_from_here?(x, y, color, game_state)
    if game_state[x][y] == color &&
      game_state[x - 1][y + 1] == color &&
      game_state[x - 2][y + 2] == color &&
      game_state[x - 3][y + 3] == color
      return true
    end
  end

end
