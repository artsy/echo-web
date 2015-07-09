require 'rails_helper'

RSpec.describe 'accounts/new.html.erb', type: :view do
  context 'anonymous user' do
    before do
      root_request
      page.visit new_account_url
    end

    it 'renders a new account form' do
      expect(find_field('Name').visible?).to eq true
    end
  end
end
