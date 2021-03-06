require 'rails_helper'

RSpec.describe 'accounts/routes/edit.html.erb', type: :view do
  let(:account) { Fabricate(:account, id: 'account-0') }
  let(:route) { Fabricate(:route, account_id: account.id) }

  let(:account_response) { hypermedia_resource_json_for account }
  let(:account_find_request) do
    uri = Regexp.new "#{Account.api_root}/accounts/#{account.id}"
    WebMock.stub_request(:get, uri)
      .with(headers: { 'Http-Authorization' => Account.api_token })
      .to_return(status: 200, body: account_response)
  end
  let(:route_response) { hypermedia_resource_json_for route }
  let(:route_find_request) do
    uri = Regexp.new "#{Account.api_root}/routes/#{route.id}"
    WebMock.stub_request(:get, uri)
      .with(headers: { 'Http-Authorization' => Route.api_token })
      .to_return(status: 200, body: route_response)
  end

  context 'logged in user' do
    include_context 'logged in user'
    before do
      root_request
      account_find_request
      route_find_request
      page.visit edit_account_route_path(account, route)
    end

    it 'renders edit route form' do
      expect(find_field('Name').value).to eq route.name
    end
  end
end
