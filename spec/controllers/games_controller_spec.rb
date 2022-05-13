require 'rails_helper'

describe GamesController do
  describe '#index' do
    it 'renders' do
      expect(GameState).to receive(:winner?)
      expect(GameState).to receive(:draw?)

      get :index

      expect(response).to be_successful
    end

    describe "GameState permutations" do
      context 'GameState indicates a winner' do
        it "assigns red-win message" do
          expect(GameState).to receive(:winner?).and_return(:red)
          expect(GameState).not_to receive(:draw?)

          get :index

          expect(assigns[:message]).to eq "RED won!"
          expect(response).to be_successful
        end
      end

      context 'GameState indicates a draw condition' do
        it "assigns draw message" do
          expect(GameState).to receive(:winner?).and_return(nil)
          expect(GameState).to receive(:draw?).and_return(true)

          get :index

          expect(assigns[:message]).to eq "Draw!"
          expect(response).to be_successful
        end
      end

      context 'GameState indicates a neither winner nor a draw condition' do
        it "assigns red-win message" do
          expect(GameState).to receive(:winner?).and_return(nil)
          expect(GameState).to receive(:draw?).and_return(false)

          get :index

          expect(assigns[:message]).to be_nil
          expect(response).to be_successful
        end
      end
    end
  end

  describe '#reset' do
    it 'calls reset on Game state and redirects to index' do
      expect(GameState).to receive(:reset)
      post :reset
      expect(response).to redirect_to(root_path)
    end
  end
end
