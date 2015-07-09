require 'rails_helper'

RSpec.describe 'accounts/show.html.erb', type: :view do
  let(:account) { Fabricate(:account) }
  let(:resource_response) { hypermedia_resource_json_for account }
  let(:resource_find_request) do
    uri = Regexp.new "#{Account.api_root}/accounts/#{account.id}"
    WebMock.stub_request(:get, uri)
      .with(headers: { 'Http-Authorization' => Account.api_token })
      .to_return(status: 200, body: resource_response)
  end

  context 'logged in user' do
    include_context 'logged in user'
    before do
      root_request
      resource_find_request
      page.visit account_url(account)
    end

    it 'renders account details' do
      expect(page).to have_content account.name
    end
  end
end
