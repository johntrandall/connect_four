require 'rails_helper'

describe 'game requests' do
  describe '/' do
    it 'renders' do
      get "/"
      expect(response).to render_template(:index)
    end
  end
end
