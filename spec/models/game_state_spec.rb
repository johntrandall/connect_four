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

  describe ".modify_board_state" do
    it 'modifies game state by dropping a chit in the column and respecting gravity' do
      expect { GameState.modify_board_state(0) }
        .to change { GameState.game_state }
              .from([
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil]
                    ])
              .to([
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [:red, nil, nil, nil, nil, nil]
                  ])

      expect { GameState.modify_board_state(0) }
        .to change { GameState.game_state }
              .from([
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [:red, nil, nil, nil, nil, nil]
                    ])
              .to([
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [:red, nil, nil, nil, nil, nil],
                    [:red, nil, nil, nil, nil, nil]
                  ])

      expect { GameState.modify_board_state(2) }
        .to change { GameState.game_state }
              .from([
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [:red, nil, nil, nil, nil, nil],
                      [:red, nil, nil, nil, nil, nil]
                    ])
              .to([
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [:red, nil, nil, nil, nil, nil],
                    [:red, nil, :red, nil, nil, nil]
                  ])

    end

    it 'drops the correct color Chit based on .current_player' do
      pending("This fails due to test pollution. TODO: Must avoid using class variables or clean-up properly")
      expect(GameState).to receive(:current_player).and_return(:unicorn)

      expect { GameState.modify_board_state(0) }
        .to change { GameState.game_state }
              .from([
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil]
                    ])
              .to([
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil],
                    [:unicorn, nil, nil, nil, nil, nil]
                  ])
    end
  end

  describe ".flip_player" do
    pending('already wotking in GUI, TODO: backfill test here')
  end

  describe ".check_for_win_condition" do
    context "no win" do
      it 'returns nil' do
        expect(GameState).to receive(:check_for_horizontal_win).and_return(false)
        expect(GameState).to receive(:check_for_vertical_win).and_return(false)
        expect(GameState).to receive(:check_for_diagonal_win).and_return(false)

        expect(GameState.winner?).to eq false
      end
    end

    context "horizontal win" do
      it 'returns winner' do
        expect(GameState).to receive(:check_for_horizontal_win).and_return(:red)

        expect(GameState.winner?).to eq :red
      end
    end

    context "veritcal win" do
      it 'returns winner' do
        expect(GameState).to receive(:check_for_horizontal_win).and_return(false)
        expect(GameState).to receive(:check_for_vertical_win).and_return(:blue)

        expect(GameState.winner?).to eq :blue
      end
    end

    context "diagonal win" do
      it 'returns winner' do
        expect(GameState).to receive(:check_for_horizontal_win).and_return(false)
        expect(GameState).to receive(:check_for_vertical_win).and_return(false)
        expect(GameState).to receive(:check_for_diagonal_win).and_return(:red)

        expect(GameState.winner?).to eq :red
      end
    end
  end

end
