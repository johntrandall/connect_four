require 'rails_helper'

describe GameState do

  describe "starting state" do
    describe ".game_state" do
      it 'returns an array with nothing in it' do
        expect(GameState.game_state).to be_a(Array)
        expect(GameState.game_state.flatten.compact).to eq([])
      end
    end

    describe ".current_player" do
      it 'returns :red' do
        expect(GameState.current_player).to eq :red
      end
    end
  end

end
