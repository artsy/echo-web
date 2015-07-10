require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  context 'anonymous user' do
    it 'responds with a 401 status to GET requests' do
      [:index, :new, :edit, :show].each do |action|
        get action, id: 123
        expect(response.status).to be 401
      end
    end
    it 'responds with a 401 status to POST requests' do
      post :create
      expect(response.status).to be 401
    end
    it 'responds with a 401 status to PATCH requests' do
      patch :update, id: 123
      expect(response.status).to be 401
    end
    it 'responds with a 401 status to DELETE requests' do
      delete :destroy, id: 123
      expect(response.status).to be 401
    end
  end

  context 'logged in user' do
    include_context 'logged in user'

    let(:account) { Fabricate(:account) }
    let(:resource_response) { hypermedia_resource_json_for account }
    let(:resource_find_request) do
      uri = Regexp.new "#{Account.api_root}/accounts/#{account.id}"
      WebMock.stub_request(:get, uri)
        .with(headers: { 'Http-Authorization' => Account.api_token })
        .to_return(status: 200, body: resource_response)
    end

    describe "GET 'index'" do
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
      end
      it 'renders the index template' do
        get :index
        expect(response.status).to be 200
        expect(response).to render_template('index')
      end
      it 'assigns @page to be 1 by default' do
        get :index
        expect(assigns(:page)).to eq 1
      end
      it 'assigns @page to params[:page].to_i' do
        get :index, page: '2'
        expect(assigns(:page)).to eq 2
      end
      it 'assigns @size to be 10 by default' do
        get :index
        expect(assigns(:size)).to eq 10
      end
      it 'assigns @size to params[:size].to_i' do
        get :index, size: '2'
        expect(assigns(:size)).to eq 2
      end
      it 'assigns @accounts.previous_link' do
        get :index
        expect(assigns(:accounts).previous_link).to_not be_nil
      end
      it 'assigns @accounts.next_link' do
        get :index
        expect(assigns(:accounts).next_link).to_not be_nil
      end
      it 'assigns @accounts' do
        get :index
        expect(assigns(:accounts).count).to eq accounts.size
        expect(assigns(:accounts).first.name).to eq account.name
      end
    end
    describe "GET 'new'" do
      it 'renders the new template' do
        get :new
        expect(response.status).to be 200
        expect(response).to render_template('new')
      end
    end

    context "POST 'create'"  do
      let(:resource_create_request) do
        uri = Regexp.new "#{Account.api_root}/accounts"
        WebMock.stub_request(:post, uri)
          .with(headers: { 'Http-Authorization' => Account.api_token })
          .to_return(status: 200, body: resource_response)
      end
      before do
        root_request
        resource_create_request
        post :create, account: { name: 'hello' }
      end
      it 'redirects to account_path(@account)' do
        expect(response.status).to be 302
        expect(response).to redirect_to(account_path(assigns(:account)))
      end
      it 'assigns @account' do
        expect(assigns(:account)).to be_a_kind_of Account
        expect(assigns(:account).id).to eq account.id
        expect(assigns(:account).name).to eq account.name
      end
      it 'makes the resource request' do
        body_str = "{\"account\":{\"name\":\"hello\"}}"
        expect(resource_create_request.with(body: body_str)).to have_been_requested
      end
    end

    describe "GET 'show'" do
      before do
        root_request
        resource_find_request
        get :show, id: account.id
      end
      it 'renders the show template' do
        expect(response.status).to be 200
        expect(response).to render_template('show')
      end
      it 'assigns @account_id' do
        expect(assigns(:account_id)).to eq Rails.application.config_for(:echo_api)['account_id']
      end
      it 'assigns @account' do
        expect(assigns(:account)).to be_a_kind_of Account
        expect(assigns(:account).id).to eq account.id
        expect(assigns(:account).name).to eq account.name
      end
    end

    describe "GET 'edit'" do
      before do
        root_request
        resource_find_request
        get :edit, id: account.id
      end
      it 'renders the edit template' do
        expect(response.status).to be 200
        expect(response).to render_template('edit')
      end
      it 'assigns @account' do
        expect(assigns(:account)).to be_a_kind_of Account
        expect(assigns(:account).id).to eq account.id
        expect(assigns(:account).name).to eq account.name
      end
    end

    describe "PATCH 'update'" do
      let(:resource_update_request) do
        uri = Regexp.new "#{Account.api_root}/accounts/#{account.id}"
        WebMock.stub_request(:patch, uri)
          .with(headers: { 'Http-Authorization' => Account.api_token })
          .to_return(status: 200, body: resource_response)
      end

      before do
        root_request
        resource_find_request
        resource_update_request
        patch :update, id: account.id, account: { name: 'hello' }
      end
      it 'redirects to account_path(@account)' do
        expect(response.status).to be 302
        expect(response).to redirect_to(account_path(assigns(:account)))
      end
      it 'assigns @account' do
        expect(assigns(:account)).to be_a_kind_of Account
        expect(assigns(:account).id).to eq account.id
        expect(assigns(:account).name).to eq account.name
      end
      it 'makes the resource update request' do
        expect(resource_update_request).to have_been_requested
      end
      it 'makes the resource find request' do
        expect(resource_find_request).to have_been_requested
      end
    end

    describe "DELETE 'destroy'" do
      let(:resource_delete_request) do
        uri = Regexp.new "#{Account.api_root}/accounts/#{account.id}"
        WebMock.stub_request(:delete, uri)
          .with(headers: { 'Http-Authorization' => Account.api_token })
          .to_return(status: 200, body: resource_response)
      end
      before do
        root_request
        resource_find_request
        resource_delete_request
        delete :destroy, id: account.id
      end
      it 'redirects to account_path(@account)' do
        expect(response.status).to be 302
        expect(response).to redirect_to(accounts_path)
      end
      it 'makes the resource delete request' do
        expect(resource_delete_request).to have_been_requested
      end
      it 'makes the resource find request' do
        expect(resource_find_request).to have_been_requested
      end
    end
  end
end
