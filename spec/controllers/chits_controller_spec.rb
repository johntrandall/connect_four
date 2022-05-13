require 'rails_helper'

describe ChitsController do

  it 'redirects back to root' do
    expect(GameState).to receive(:new).and_return(mock_game_state = GameState.new)

    expect(mock_game_state).to receive(:modify_board_state)
    expect(mock_game_state).to receive(:flip_player)

    post :create

    expect(response).to be_redirect
  end

  describe '#create' do
    it "calls GameState.modify_board_state and .flip_player" do
      expect(GameState).to receive(:new).and_return(mock_game_state = GameState.new)

      expect(mock_game_state).to receive(:modify_board_state)
      expect(mock_game_state).to receive(:flip_player)

      post :create
    end
  end
end
