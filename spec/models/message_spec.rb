require 'rails_helper'

RSpec.describe Message, type: :model do
  context 'HyperclientModel' do
    it 'should extend Braque::Model' do
      expect(Message).to include(Braque::Model)
    end
    it 'provides the correct .api_root' do
      expect(Message.api_root).to eq Rails.application.config_for(:echo_api)['url']
    end
    it 'provides the correct .api_token' do
      expect(Message.api_token).to eq Rails.application.config_for(:echo_api)['token']
    end
  end
  context 'attributes' do
    it 'should include expected keys' do
      expect(Message.attributes.keys).to include(
        'id', 'name', 'content', 'account_id', 'created_at', 'updated_at'
      )
    end
  end
end
