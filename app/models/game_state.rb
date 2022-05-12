class GameState
  @@game_state = [
    [nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil]
  ]
  @@current_player = :red


  def self.game_state
    @@game_state
  end

  def self.current_player
    @@current_player
  end

  def self.modify_board_state(column_num)
    deepest_nil_row = nil
    game_state.each_with_index do |row, i|
      if row[column_num].nil?
        deepest_nil_row = i
      end

      # drop it in
      game_state[deepest_nil_row][column_num] = current_player
    end
  end

  def self.flip_player
    @@current_player = :black if @@current_player == :red
    @@current_player = :red if @@current_player == :black
  end

  def self.check_for_win_condition
    check_for_horizontal_win || check_for_vertical_win || check_for_diagonal_win
  end

  def self.check_for_draw_condition
    return false if @game_state.flatten.include?(0)
    return true
  end

  private

  def self.check_for_horizontal_win
    game_state.each do |row|
      return :black if win_row(row, :black)
      return :red if win_row(row, :red)
    end
  end

  def self.win_row(row, color)
    counter = 0
    row.each do |slot|
      if slot == color
        counter += 1
      else
        counter = 0
      end
    end
    return color if counter >= 4
  end

  def self.check_for_vertical_win
    game_state.transpose.each do |row|
      return :black if win_row?(row, :black)
      return :red if win_row?(row, :red)
    end
  end

  def self.check_for_diagonal_win
    raise 'TODO: check_for_diagonal_win'
  end
end
