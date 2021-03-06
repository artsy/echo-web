require 'rails_helper'

RSpec.describe 'accounts/messages/new.html.erb', type: :view do
  let(:account) { Fabricate(:account, id: 'account-0') }
  let(:account_response) { hypermedia_resource_json_for account }
  let(:account_find_request) do
    uri = Regexp.new "#{Account.api_root}/accounts/#{account.id}"
    WebMock.stub_request(:get, uri)
      .with(headers: { 'Http-Authorization' => Account.api_token })
      .to_return(status: 200, body: account_response)
  end

  context 'logged in user' do
    include_context 'logged in user'
    before do
      root_request
      account_find_request
      page.visit new_account_message_path(account)
    end

    it 'renders a new message form' do
      expect(find_field('Name').visible?).to eq true
    end
  end
end
