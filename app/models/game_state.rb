class GameState
  def self.get_game_state
    Rails.cache.fetch (:get_game_state) do
      [
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil]
      ]
    end
  end

  def self.get_current_player
    Rails.cache.fetch (:current_player) do
      :red
    end
  end

  def self.modify_board_state(column_num)
    deepest_nil_row = nil
    get_game_state.each_with_index do |row, i|
      if row[column_num].nil?
        deepest_nil_row = i
      end
    end
    self.patch_game_state(deepest_nil_row, column_num, get_current_player)
  end

  def self.flip_player
    if self.get_current_player == :red
      self.set_current_player(:black)
      return :black
    end
    if self.get_current_player == :black
      self.set_current_player(:red)
      return :red
    end
  end

  def self.winner?
    horizontal_winner || vertical_winner || diagonal_winner
  end

  def self.draw?
    return false if @game_state.flatten.include?(0)
    return true
  end

  private

  def self.set_current_player(value)
    Rails.cache.write(:current_player, value)
    value
  end

  def self.patch_game_state(row_num, col_num, current_player)
    gs_nested_array = self.get_game_state
    gs_nested_array[row_num][col_num] = current_player
    Rails.cache.write(:get_game_state, gs_nested_array)
  end

  def self.horizontal_winner
    get_game_state.each do |row|
      return :black if winner_on_row?(row, :black)
      return :red if winner_on_row?(row, :red)
    end
  end

  def self.vertical_winner
    get_game_state.transpose.each do |row|
      return :black if win_row?(row, :black)
      return :red if win_row?(row, :red)
    end
  end

  def self.winner_on_row?(row, color)
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

  def self.diagonal_winner
    raise 'TODO: check_for_diagonal_win'
  end
end
