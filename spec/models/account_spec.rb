require 'rails_helper'

RSpec.describe Account, type: :model do
  context 'HyperclientModel' do
    it 'should extend Braque::Model' do
      expect(Account).to include(Braque::Model)
    end
    it 'provides the correct .api_root' do
      expect(Account.api_root).to eq Rails.application.config_for(:echo_api)['url']
    end
    it 'provides the correct .api_token' do
      expect(Account.api_token).to eq Rails.application.config_for(:echo_api)['token']
    end
  end
  context 'attributes' do
    it 'should include expected keys' do
      expect(Account.attributes.keys).to include(
        'id', 'name', 'created_at', 'updated_at'
      )
    end
  end
end
