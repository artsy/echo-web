require 'rails_helper'

RSpec.describe Accounts::FeaturesController, type: :controller do
  it_behaves_like 'namespaced authenticated controllers'

  context 'logged in user' do
    include_context 'logged in user'

    let(:account) { Fabricate(:account, id: 'account-0') }
    let(:feature) { Fabricate(:feature, account_id: account.id) }
    let(:account_response) { hypermedia_resource_json_for account }
    let(:account_find_request) do
      uri = Regexp.new "#{Account.api_root}/accounts/#{account.id}"
      WebMock.stub_request(:get, uri)
        .with(headers: { 'Http-Authorization' => Account.api_token })
        .to_return(status: 200, body: account_response)
    end
    let(:feature_response) { hypermedia_resource_json_for feature }
    let(:feature_find_request) do
      uri = Regexp.new "#{Account.api_root}/features/#{feature.id}"
      WebMock.stub_request(:get, uri)
        .with(headers: { 'Http-Authorization' => Feature.api_token })
        .to_return(status: 200, body: feature_response)
    end

    before do
      root_request
      account_find_request
    end

    describe "GET 'index'" do
      let(:features) { [feature] }
      let(:collection_response) { hypermedia_collection_json_for features }
      let(:collection_request) do
        uri = Regexp.new "#{Account.api_root}/features*"
        WebMock.stub_request(:get, uri)
          .with(headers: { 'Http-Authorization' => Feature.api_token })
          .to_return(status: 200, body: collection_response)
      end

      before do
        collection_request
      end

      it 'renders the index template' do
        get :index, account_id: account.id
        expect(response.status).to be 200
        expect(response).to render_template('index')
      end
      it 'assigns @page to be 1 by default' do
        get :index, account_id: account.id
        expect(assigns(:page)).to eq 1
      end
      it 'assigns @page to params[:page].to_i' do
        get :index, account_id: account.id, page: '2'
        expect(assigns(:page)).to eq 2
      end
      it 'assigns @size to be 10 by default' do
        get :index, account_id: account.id
        expect(assigns(:size)).to eq 10
      end
      it 'assigns @size to params[:size].to_i' do
        get :index, account_id: account.id, size: '2'
        expect(assigns(:size)).to eq 2
      end
      it 'assigns @features.previous_link' do
        get :index, account_id: account.id
        expect(assigns(:features).previous_link).to_not be_nil
      end
      it 'assigns @accounts.next_link' do
        get :index, account_id: account.id
        expect(assigns(:features).next_link).to_not be_nil
      end
      it 'assigns @features' do
        get :index, account_id: account.id
        expect(assigns(:features).count).to eq features.size
        expect(assigns(:features).first.name).to eq feature.name
      end
    end

    describe "GET 'new'" do
      it 'renders the new template' do
        get :new, account_id: account.id
        expect(response.status).to be 200
        expect(response).to render_template('new')
      end
    end

    describe "POST 'create'" do
      let(:feature_create_request) do
        uri = Regexp.new "#{Feature.api_root}/features"
        WebMock.stub_request(:post, uri)
          .with(headers: { 'Http-Authorization' => Feature.api_token })
          .to_return(status: 200, body: feature_response)
      end

      before do
        feature_create_request
        post :create, account_id: account.id, feature: { name: 'hello' }
      end

      it 'redirects to account_feature_path(@account, @feature)' do
        expect(response.status).to be 302
        expect(response).to redirect_to(account_feature_path(assigns(:account), assigns(:feature)))
      end
      it 'assigns @account' do
        expect(assigns(:account)).to be_a_kind_of Account
        expect(assigns(:account).id).to eq account.id
        expect(assigns(:account).name).to eq account.name
      end
      it 'assigns @feature' do
        expect(assigns(:feature)).to be_a_kind_of Feature
        expect(assigns(:feature).id).to eq feature.id
        expect(assigns(:feature).name).to eq feature.name
      end
      it 'makes the resource request' do
        body_str = "{\"feature\":{\"name\":\"hello\",\"account_id\":\"account-0\"}}"
        expect(feature_create_request.with(body: body_str)).to have_been_requested
      end
    end

    describe "GET 'show'" do
      before do
        feature_find_request
        get :show, id: feature.id, account_id: account.id
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
      it 'assigns @feature' do
        expect(assigns(:feature)).to be_a_kind_of Feature
        expect(assigns(:feature).id).to eq feature.id
        expect(assigns(:feature).name).to eq feature.name
      end
    end

    describe "GET 'edit'" do
      before do
        feature_find_request
        get :edit, id: feature.id, account_id: account.id
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
      it 'assigns @feature' do
        expect(assigns(:feature)).to be_a_kind_of Feature
        expect(assigns(:feature).id).to eq feature.id
        expect(assigns(:feature).name).to eq feature.name
      end
    end

    describe "PATCH 'update'" do
      let(:feature_update_request) do
        uri = Regexp.new "#{Feature.api_root}/features/#{feature.id}"
        WebMock.stub_request(:patch, uri)
          .with(headers: { 'Http-Authorization' => Feature.api_token })
          .to_return(status: 200, body: feature_response)
      end

      before do
        feature_find_request
        feature_update_request
        patch :update, id: feature.id, feature: { name: 'hello' }, account_id: account.id
      end
      it 'redirects to account_feature_path(@account, @feature)' do
        expect(response.status).to be 302
        expect(response).to redirect_to(account_feature_path(assigns(:account), assigns(:feature)))
      end
      it 'assigns @account' do
        expect(assigns(:account)).to be_a_kind_of Account
        expect(assigns(:account).id).to eq account.id
        expect(assigns(:account).name).to eq account.name
      end
      it 'assigns @feature' do
        expect(assigns(:feature)).to be_a_kind_of Feature
        expect(assigns(:feature).id).to eq feature.id
        expect(assigns(:feature).name).to eq feature.name
      end
      it 'makes the feature update request' do
        expect(feature_update_request).to have_been_requested
      end
      it 'makes the feature find request' do
        expect(feature_find_request).to have_been_requested
      end
      it 'makes the account find request' do
        expect(account_find_request).to have_been_requested
      end
    end

    describe "DELETE 'destroy'" do
      let(:feature_delete_request) do
        uri = Regexp.new "#{Feature.api_root}/features/#{feature.id}"
        WebMock.stub_request(:delete, uri)
          .with(headers: { 'Http-Authorization' => Feature.api_token })
          .to_return(status: 200, body: feature_response)
      end

      before do
        feature_find_request
        feature_delete_request
        delete :destroy, id: feature.id, account_id: account.id
      end
      it 'redirects to account_features_path(@account)' do
        expect(response.status).to be 302
        expect(response).to redirect_to(account_features_path(assigns(:account)))
      end
      it 'makes the feature delete request' do
        expect(feature_delete_request).to have_been_requested
      end
      it 'makes the account find request' do
        expect(account_find_request).to have_been_requested
      end
      it 'makes the feature find request' do
        expect(feature_find_request).to have_been_requested
      end
    end
  end
end
