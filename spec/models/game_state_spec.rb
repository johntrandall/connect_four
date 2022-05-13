require 'rails_helper'

describe GameState do
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
  let(:cache) { Rails.cache }

  before do
    allow(Rails).to receive(:cache).and_return(memory_store)
    Rails.cache.clear
  end

  it "Sanity Test: prove that caching is enabled in test" do
    expect(Rails.cache.read(:current_player)).to eq nil

    expect(GameState.get_current_player).to eq :red
    expect(Rails.cache.read(:current_player)).to eq :red
    expect(GameState.get_current_player).to eq :red

    expect(GameState.set_current_player(:unicorn)).to eq :unicorn
    expect(Rails.cache.read(:current_player)).to eq :unicorn
    expect(GameState.get_current_player).to eq :unicorn
  end

  describe "starting state" do
    describe ".get_game_state" do
      it 'returns an array with no pieces in it' do
        expect(GameState.get_game_state).to be_a(Array)
        expect(GameState.get_game_state.flatten.compact).to eq([])
      end

      it 'returns the starting state nested array of nils' do
        expect(GameState.get_game_state).to eq(
                                              [
                                                [nil, nil, nil, nil, nil, nil, nil],
                                                [nil, nil, nil, nil, nil, nil, nil],
                                                [nil, nil, nil, nil, nil, nil, nil],
                                                [nil, nil, nil, nil, nil, nil, nil],
                                                [nil, nil, nil, nil, nil, nil, nil],
                                                [nil, nil, nil, nil, nil, nil, nil]
                                              ]
                                            )
      end
    end

    describe ".current_player" do
      it 'returns :red' do
        expect(GameState.get_current_player).to eq :red
      end
    end
  end

  describe ".modify_board_state" do
    it 'modifies game state by dropping a chit in the column and respecting gravity' do
      expect { GameState.modify_board_state(0) }
        .to change { GameState.get_game_state }
              .from([
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil]
                    ])
              .to([
                    [nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [:red, nil, nil, nil, nil, nil, nil]
                  ])

      expect { GameState.modify_board_state(0) }
        .to change { GameState.get_game_state }
              .from([
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [:red, nil, nil, nil, nil, nil, nil]
                    ])
              .to([
                    [nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [:red, nil, nil, nil, nil, nil, nil],
                    [:red, nil, nil, nil, nil, nil, nil]
                  ])
      #
      expect { GameState.modify_board_state(2) }
        .to change { GameState.get_game_state }
              .from([
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [:red, nil, nil, nil, nil, nil, nil],
                      [:red, nil, nil, nil, nil, nil, nil]
                    ])
              .to([
                    [nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [:red, nil, nil, nil, nil, nil, nil],
                    [:red, nil, :red, nil, nil, nil, nil]
                  ])

    end

    it 'drops the correct color Chit based on .current_player' do
      expect(GameState).to receive(:get_current_player).and_return(:unicorn)

      expect { GameState.modify_board_state(0) }
        .to change { GameState.get_game_state }
              .from([
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil]
                    ])
              .to([
                    [nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [:unicorn, nil, nil, nil, nil, nil, nil]
                  ])
    end
  end

  describe ".flip_player" do
    it 'flips .current_player back and forth from red to black' do
      expect(GameState.get_current_player).to eq :red
      expect { GameState.flip_player }
        .to change { GameState.get_current_player }
              .from(:red).to(:black)
      expect { GameState.flip_player }
        .to change { GameState.get_current_player }
              .from(:black).to(:red)
      expect { GameState.flip_player }
        .to change { GameState.get_current_player }
              .from(:red).to(:black)
    end
  end

  describe ".winner?" do
    context "no win" do
      it 'returns nil' do
        expect(GameState).to receive(:horizontal_winner).and_return(nil)
        expect(GameState).to receive(:vertical_winner).and_return(nil)
        expect(GameState).to receive(:diagonal_winner).and_return(nil)

        expect(GameState.winner?).to eq nil
      end
    end

    context "horizontal win" do
      it 'returns winner' do
        expect(GameState).to receive(:horizontal_winner).and_return(:red)

        expect(GameState.winner?).to eq :red
      end
    end

    context "veritcal win" do
      it 'returns winner' do
        expect(GameState).to receive(:horizontal_winner).and_return(false)
        expect(GameState).to receive(:vertical_winner).and_return(:blue)

        expect(GameState.winner?).to eq :blue
      end
    end

    context "diagonal win" do
      it 'returns winner' do
        expect(GameState).to receive(:horizontal_winner).and_return(false)
        expect(GameState).to receive(:vertical_winner).and_return(false)
        expect(GameState).to receive(:diagonal_winner).and_return(:red)

        expect(GameState.winner?).to eq :red
      end
    end
  end

  describe ".draw?" do
    pending("TODO - write tests")
  end

  describe "column_full?" do
    it "returns true/false accurately" do
      allow(GameState)
        .to receive(:get_game_state)
              .and_return [
                            [nil, :x, nil, nil, nil, nil, nil],
                            [nil, :x, nil, nil, nil, nil, nil],
                            [nil, :x, nil, nil, nil, nil, nil],
                            [nil, :x, nil, nil, nil, nil, nil],
                            [:black, :black, nil, nil, nil, nil, nil],
                            [nil, :red, nil, nil, nil, nil, nil]
                          ]
      expect(GameState.column_full?(0)).to eq false
      expect(GameState.column_full?(1)).to eq true
      expect(GameState.column_full?(2)).to eq false
    end
  end

  describe 'private' do

    describe '#horizontal_winner' do
      it 'returns nil if there is no horizontal winner' do
        game_state = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [:black, nil, nil, nil, nil, nil, nil],
          [:red, nil, nil, nil, nil, nil, nil],
          [:black, :black, :black, nil, nil, nil, nil],
          [:red, :red, :red, nil, nil, nil, nil]
        ]
        expect(GameState.horizontal_winner(game_state)).to eq nil
      end

      it 'returns the color if there is a horizontal winner' do
        game_state = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [:black, nil, nil, nil, nil, nil, nil],
          [:red, nil, nil, nil, nil, nil, nil],
          [:black, :black, :black, nil, nil, nil, nil],
          [:red, :red, :red, :red, nil, nil, nil]
        ]
        expect(GameState.horizontal_winner(game_state)).to eq :red
      end
    end

    describe '#diagonal_winner' do
      it 'returns nil if there is no diagonal winner' do
        game_state = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [:red, nil, nil, nil, nil, nil, nil],
          [nil, :red, nil, nil, nil, nil, nil],
          [nil, nil, :red, nil, nil, nil, nil]
        ]

        expect(GameState.diagonal_winner(game_state)).to eq nil
      end

      it 'returns the winner if there is a diagonal down_right winner' do
        game_state = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [:red, nil, nil, nil, nil, nil, nil],
          [nil, :red, nil, nil, nil, nil, nil],
          [nil, nil, :red, nil, nil, nil, nil],
          [nil, nil, nil, :red, nil, nil, nil]
        ]

        expect(GameState.diagonal_winner(game_state)).to eq :red

        game_state = [
          [nil, nil, nil, :red, nil, nil, nil],
          [nil, nil, nil, nil, :red, nil, nil],
          [nil, nil, nil, nil, nil, :red, nil],
          [nil, nil, nil, nil, nil, nil, :red],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil]
        ]

        expect(GameState.diagonal_winner(game_state)).to eq :red
      end

      it 'returns the winner if there is a diagonal up_right winner' do
        game_state = [
          [nil, nil, nil, :black, nil, nil, nil],
          [nil, nil, :black, nil, nil, nil, nil],
          [nil, :black, nil, nil, nil, nil, nil],
          [:black, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
        ]

        expect(GameState.diagonal_winner(game_state)).to eq :black

        game_state = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, :black],
          [nil, nil, nil, nil, nil, :black, nil],
          [nil, nil, nil, nil, :black, nil, nil],
          [nil, nil, nil, :black, nil, nil, nil],
        ]
        expect(GameState.diagonal_winner(game_state)).to eq :black
      end
    end

  end
end
