require 'rails_helper'

RSpec.describe 'accounts/messages/edit.html.erb', type: :view do
  let(:account) { Fabricate(:account, id: 'account-0') }
  let(:message) { Fabricate(:message, account_id: account.id) }

  let(:account_response) { hypermedia_resource_json_for account }
  let(:account_find_request) do
    uri = Regexp.new "#{Account.api_root}/accounts/#{account.id}"
    WebMock.stub_request(:get, uri)
      .with(headers: { 'Http-Authorization' => Account.api_token })
      .to_return(status: 200, body: account_response)
  end
  let(:message_response) { hypermedia_resource_json_for message }
  let(:message_find_request) do
    uri = Regexp.new "#{Account.api_root}/messages/#{message.id}"
    WebMock.stub_request(:get, uri)
      .with(headers: { 'Http-Authorization' => Message.api_token })
      .to_return(status: 200, body: message_response)
  end

  context 'anonymous user' do
    before do
      root_request
      account_find_request
      message_find_request
      page.visit edit_account_message_path(account, message)
    end

    it 'renders edit message form' do
      expect(find_field('Name').value).to eq message.name
    end
  end
end
