require 'rails_helper'

RSpec.describe Accounts::RoutesController, type: :controller do
  it_behaves_like 'namespaced authenticated controllers'

  context 'logged in user' do
    include_context 'logged in user'

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

    before do
      root_request
      account_find_request
    end

    describe "GET 'index'" do
      let(:routes) { [route] }
      let(:collection_response) { hypermedia_collection_json_for routes }
      let(:collection_request) do
        uri = Regexp.new "#{Account.api_root}/routes*"
        WebMock.stub_request(:get, uri)
          .with(headers: { 'Http-Authorization' => Route.api_token })
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
      it 'assigns @routes.previous_link' do
        get :index, account_id: account.id
        expect(assigns(:routes).previous_link).to_not be_nil
      end
      it 'assigns @accounts.next_link' do
        get :index, account_id: account.id
        expect(assigns(:routes).next_link).to_not be_nil
      end
      it 'assigns @routes' do
        get :index, account_id: account.id
        expect(assigns(:routes).count).to eq routes.size
        expect(assigns(:routes).first.name).to eq route.name
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
      let(:route_create_request) do
        uri = Regexp.new "#{Route.api_root}/routes"
        WebMock.stub_request(:post, uri)
          .with(headers: { 'Http-Authorization' => Route.api_token })
          .to_return(status: 200, body: route_response)
      end

      before do
        route_create_request
        post :create, account_id: account.id, route: { name: 'hello' }
      end

      it 'redirects to account_route_path(@account, @route)' do
        expect(response.status).to be 302
        expect(response).to redirect_to(account_route_path(assigns(:account), assigns(:route)))
      end
      it 'assigns @account' do
        expect(assigns(:account)).to be_a_kind_of Account
        expect(assigns(:account).id).to eq account.id
        expect(assigns(:account).name).to eq account.name
      end
      it 'assigns @route' do
        expect(assigns(:route)).to be_a_kind_of Route
        expect(assigns(:route).id).to eq route.id
        expect(assigns(:route).name).to eq route.name
      end
      it 'makes the resource request' do
        body_str = "{\"route\":{\"name\":\"hello\",\"account_id\":\"account-0\"}}"
        expect(route_create_request.with(body: body_str)).to have_been_requested
      end
    end

    describe "GET 'show'" do
      before do
        route_find_request
        get :show, id: route.id, account_id: account.id
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
      it 'assigns @route' do
        expect(assigns(:route)).to be_a_kind_of Route
        expect(assigns(:route).id).to eq route.id
        expect(assigns(:route).name).to eq route.name
      end
    end

    describe "GET 'edit'" do
      before do
        route_find_request
        get :edit, id: route.id, account_id: account.id
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
      it 'assigns @route' do
        expect(assigns(:route)).to be_a_kind_of Route
        expect(assigns(:route).id).to eq route.id
        expect(assigns(:route).name).to eq route.name
      end
    end

    describe "PATCH 'update'" do
      let(:route_update_request) do
        uri = Regexp.new "#{Route.api_root}/routes/#{route.id}"
        WebMock.stub_request(:patch, uri)
          .with(headers: { 'Http-Authorization' => Route.api_token })
          .to_return(status: 200, body: route_response)
      end

      before do
        route_find_request
        route_update_request
        patch :update, id: route.id, route: { name: 'hello' }, account_id: account.id
      end
      it 'redirects to account_route_path(@account, @route)' do
        expect(response.status).to be 302
        expect(response).to redirect_to(account_route_path(assigns(:account), assigns(:route)))
      end
      it 'assigns @account' do
        expect(assigns(:account)).to be_a_kind_of Account
        expect(assigns(:account).id).to eq account.id
        expect(assigns(:account).name).to eq account.name
      end
      it 'assigns @route' do
        expect(assigns(:route)).to be_a_kind_of Route
        expect(assigns(:route).id).to eq route.id
        expect(assigns(:route).name).to eq route.name
      end
      it 'makes the route update request' do
        expect(route_update_request).to have_been_requested
      end
      it 'makes the route find request' do
        expect(route_find_request).to have_been_requested
      end
      it 'makes the account find request' do
        expect(account_find_request).to have_been_requested
      end
    end

    describe "DELETE 'destroy'" do
      let(:route_delete_request) do
        uri = Regexp.new "#{Route.api_root}/routes/#{route.id}"
        WebMock.stub_request(:delete, uri)
          .with(headers: { 'Http-Authorization' => Route.api_token })
          .to_return(status: 200, body: route_response)
      end

      before do
        route_find_request
        route_delete_request
        delete :destroy, id: route.id, account_id: account.id
      end
      it 'redirects to account_routes_path(@account)' do
        expect(response.status).to be 302
        expect(response).to redirect_to(account_routes_path(assigns(:account)))
      end
      it 'makes the route delete request' do
        expect(route_delete_request).to have_been_requested
      end
      it 'makes the account find request' do
        expect(account_find_request).to have_been_requested
      end
      it 'makes the route find request' do
        expect(route_find_request).to have_been_requested
      end
    end
  end
end
