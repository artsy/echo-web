require 'rails_helper'

RSpec.describe 'accounts/routes/new.html.erb', type: :view do
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

  context 'anonymous user' do
    before do
      root_request
      account_find_request
      route_find_request
      page.visit account_route_path(account, route)
    end

    it 'renders the route details' do
      expect(page).to have_content route.name
    end
  end
end
