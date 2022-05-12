require 'rails_helper'

describe GameController do
  describe '#index' do
    it 'renders' do
      expect(GameState).to receive(:check_for_win_condition)
      expect(GameState).to receive(:check_for_draw_condition)

      get :index

      expect(response).to be_successful
    end

    describe "GameState permutations" do
      context 'GameState indicates a winner' do
        it "assigns red-win message" do
          expect(GameState).to receive(:check_for_win_condition).and_return(:red)
          expect(GameState).not_to receive(:check_for_draw_condition)

          get :index

          expect(assigns[:message]).to eq "RED won!"
          expect(response).to be_successful
        end
      end

      context 'GameState indicates a draw condition' do
        it "assigns draw message" do
          expect(GameState).to receive(:check_for_win_condition).and_return(nil)
          expect(GameState).to receive(:check_for_draw_condition).and_return(true)

          get :index

          expect(assigns[:message]).to eq "Draw!"
          expect(response).to be_successful
        end
      end

      context 'GameState indicates a neither winner nor a draw condition' do
        it "assigns red-win message" do
          expect(GameState).to receive(:check_for_win_condition).and_return(nil)
          expect(GameState).to receive(:check_for_draw_condition).and_return(false)

          get :index

          expect(assigns[:message]).to be_nil
          expect(response).to be_successful
        end
      end
    end
  end
end
