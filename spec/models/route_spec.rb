require 'rails_helper'

RSpec.describe Route, type: :model do
  context 'HyperclientModel' do
    it 'should extend Braque::Model' do
      expect(Route).to include(Braque::Model)
    end
    it 'provides the correct .api_root' do
      expect(Route.api_root).to eq Rails.application.config_for(:echo_api)['url']
    end
    it 'provides the correct .api_token' do
      expect(Route.api_token).to eq Rails.application.config_for(:echo_api)['token']
    end
  end
  context 'attributes' do
    it 'should include expected keys' do
      expect(Route.attributes.keys).to include(
        'id', 'name', 'path', 'account_id', 'created_at', 'updated_at'
      )
    end
  end
end
