require 'rails_helper'

RSpec.describe 'accounts/messages/index.html.erb', type: :view do
  let(:account) { Fabricate(:account, id: 'account-0') }
  let(:message) { Fabricate(:message, account_id: account.id) }

  let(:account_response) { hypermedia_resource_json_for account }
  let(:account_find_request) do
    uri = Regexp.new "#{Account.api_root}/accounts/#{account.id}"
    WebMock.stub_request(:get, uri)
      .with(headers: { 'Http-Authorization' => Account.api_token })
      .to_return(status: 200, body: account_response)
  end

  let(:messages) { [message] }
  let(:collection_response) { hypermedia_collection_json_for messages }
  let(:collection_request) do
    uri = Regexp.new "#{Account.api_root}/messages*"
    WebMock.stub_request(:get, uri)
      .with(headers: { 'Http-Authorization' => Message.api_token })
      .to_return(status: 200, body: collection_response)
  end

  context 'anonymous user' do
    before do
      root_request
      account_find_request
      collection_request
      page.visit account_messages_path(account)
    end

    it 'lists the account messages' do
      expect(page).to have_content message.name
    end
  end
end
