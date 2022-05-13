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
    describe ".game_state" do
      it 'returns an array with nothing in it' do
        expect(GameState.get_game_state).to be_a(Array)
        expect(GameState.get_game_state.flatten.compact).to eq([])
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
        .to change { GameState.get_game_state }
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
        .to change { GameState.get_game_state }
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
      expect(GameState).to receive(:get_current_player).and_return(:unicorn)

      expect { GameState.modify_board_state(0) }
        .to change { GameState.get_game_state }
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

end
