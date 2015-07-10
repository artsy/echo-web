def log_in
  user = Rails.application.config_for(:basic_credentials)['user']
  password = Rails.application.config_for(:basic_credentials)['password']
  credentials = ActionController::HttpAuthentication::Basic.encode_credentials(user, password)
  request.env['HTTP_AUTHORIZATION'] = credentials if request
  page.driver.browser.basic_authorize(user, password) if page
end

shared_context 'logged in user' do
  before do
    log_in
  end
end

shared_examples_for 'namespaced authenticated controllers' do
  context 'anonymous user' do
    it 'responds with a 401 status to GET requests' do
      [:index, :new, :edit, :show].each do |action|
        get action, id: 123, account_id: 234
        expect(response.status).to be 401
      end
    end
    it 'responds with a 401 status to POST requests' do
      post :create, account_id: 234
      expect(response.status).to be 401
    end
    it 'responds with a 401 status to PATCH requests' do
      patch :update, id: 123, account_id: 234
      expect(response.status).to be 401
    end
    it 'responds with a 401 status to DELETE requests' do
      delete :destroy, id: 123, account_id: 234
      expect(response.status).to be 401
    end
  end
end
