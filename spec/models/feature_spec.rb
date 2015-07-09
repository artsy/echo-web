require 'rails_helper'

RSpec.describe Feature, type: :model do
  context 'HyperclientModel' do
    it 'should extend Braque::Model' do
      expect(Feature).to include(Braque::Model)
    end
    it 'provides the correct .api_root' do
      expect(Feature.api_root).to eq Rails.application.config_for(:echo_api)['url']
    end
    it 'provides the correct .api_token' do
      expect(Feature.api_token).to eq Rails.application.config_for(:echo_api)['token']
    end
  end
  context 'attributes' do
    it 'should include expected keys' do
      expect(Feature.attributes.keys).to include(
        'id', 'name', 'value', 'account_id', 'created_at', 'updated_at'
      )
    end
  end
end
