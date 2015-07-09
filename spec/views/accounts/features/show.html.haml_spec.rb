require 'rails_helper'

RSpec.describe 'accounts/features/new.html.erb', type: :view do
  let(:account) { Fabricate(:account, id: 'account-0') }
  let(:feature) { Fabricate(:feature, account_id: account.id) }

  let(:account_response) { hypermedia_resource_json_for account }
  let(:account_find_request) do
    uri = Regexp.new "#{Account.api_root}/accounts/#{account.id}"
    WebMock.stub_request(:get, uri)
      .with(headers: { 'Http-Authorization' => Account.api_token })
      .to_return(status: 200, body: account_response)
  end
  let(:feature_response) { hypermedia_resource_json_for feature }
  let(:feature_find_request) do
    uri = Regexp.new "#{Account.api_root}/features/#{feature.id}"
    WebMock.stub_request(:get, uri)
      .with(headers: { 'Http-Authorization' => Feature.api_token })
      .to_return(status: 200, body: feature_response)
  end

  context 'anonymous user' do
    before do
      root_request
      account_find_request
      feature_find_request
      page.visit account_feature_path(account, feature)
    end

    it 'renders the feature details' do
      expect(page).to have_content feature.name
    end
  end
end
