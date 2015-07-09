require 'rails_helper'

RSpec.describe 'accounts/edit.html.erb', type: :view do
  let(:account) { Fabricate(:account) }
  let(:resource_response) { hypermedia_resource_json_for account }
  let(:resource_find_request) do
    uri = Regexp.new "#{Account.api_root}/accounts/#{account.id}"
    WebMock.stub_request(:get, uri)
      .with(headers: { 'Http-Authorization' => Account.api_token })
      .to_return(status: 200, body: resource_response)
  end

  context 'anonymous user' do
    before do
      root_request
      resource_find_request
      page.visit edit_account_url(account)
    end

    it 'renders edit account form' do
      expect(find_field('Name').value).to eq account.name
    end
  end
end
