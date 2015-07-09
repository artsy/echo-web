require 'rails_helper'

RSpec.describe 'accounts/index.html.erb', type: :view do
  context 'logged in user' do
    include_context 'logged in user'

    let(:account) { Fabricate(:account) }
    let(:accounts) { [account] }
    let(:collection_response) { hypermedia_collection_json_for accounts }
    let(:collection_request) do
      uri = Regexp.new "#{Account.api_root}/accounts*"
      WebMock.stub_request(:get, uri)
        .with(headers: { 'Http-Authorization' => Account.api_token })
        .to_return(status: 200, body: collection_response)
    end

    before do
      root_request
      collection_request
      page.visit accounts_url
    end

    it 'lists the accounts' do
      expect(page).to have_content account.name
    end
  end
end
