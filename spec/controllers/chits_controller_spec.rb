require 'rails_helper'

describe ChitsController do
  it 'redirects back to root' do
    allow(GameState).to receive(:modify_board_state)
    allow(GameState).to receive(:flip_player)

    post :create

    expect(response).to be_redirect
  end

  describe '#create' do
    it "calls GameState.modify_board_state and .flip_player" do
      expect(GameState).to receive(:modify_board_state)
      expect(GameState).to receive(:flip_player)

      post :create
    end
  end
end
