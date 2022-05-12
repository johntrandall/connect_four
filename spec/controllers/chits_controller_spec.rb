require 'rails_helper'

describe ChitsController do
  it 'redirects back to root' do
    post :create
    expect(response).to be_redirect
  end

  describe '#create' do
    it "calls GameState.modify_board_state" do
      expect(GameState).to receive(:modify_board_state)
      post :create
    end

    it "calls GameState.flip_player" do
      expect(GameState).to receive(:flip_player)
      post :create
    end
  end
end
