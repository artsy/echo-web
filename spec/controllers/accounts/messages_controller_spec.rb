require 'rails_helper'

RSpec.describe Accounts::MessagesController, type: :controller do
  let(:account) { Fabricate(:account, id: 'account-0') }
  let(:message) { Fabricate(:message, account_id: account.id) }
  let(:account_response) { hypermedia_resource_json_for account }
  let(:account_find_request) do
    uri = Regexp.new "#{Account.api_root}/accounts/#{account.id}"
    WebMock.stub_request(:get, uri)
      .with(headers: { 'Http-Authorization' => Account.api_token })
      .to_return(status: 200, body: account_response)
  end
  let(:message_response) { hypermedia_resource_json_for message }
  let(:message_find_request) do
    uri = Regexp.new "#{Account.api_root}/messages/#{message.id}"
    WebMock.stub_request(:get, uri)
      .with(headers: { 'Http-Authorization' => Message.api_token })
      .to_return(status: 200, body: message_response)
  end

  before do
    root_request
    account_find_request
  end

  describe "GET 'index'" do
    context 'anonymous user' do
      let(:messages) { [message] }
      let(:collection_response) { hypermedia_collection_json_for messages }
      let(:collection_request) do
        uri = Regexp.new "#{Account.api_root}/messages*"
        WebMock.stub_request(:get, uri)
          .with(headers: { 'Http-Authorization' => Message.api_token })
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
      it 'assigns @messages.previous_link' do
        get :index, account_id: account.id
        expect(assigns(:messages).previous_link).to_not be_nil
      end
      it 'assigns @accounts.next_link' do
        get :index, account_id: account.id
        expect(assigns(:messages).next_link).to_not be_nil
      end
      it 'assigns @messages' do
        get :index, account_id: account.id
        expect(assigns(:messages).count).to eq messages.size
        expect(assigns(:messages).first.name).to eq message.name
      end
    end
  end

  describe "GET 'new'" do
    context 'anonymous user' do
      it 'renders the new template' do
        get :new, account_id: account.id
        expect(response.status).to be 200
        expect(response).to render_template('new')
      end
    end
  end

  describe "POST 'create'" do
    let(:message_create_request) do
      uri = Regexp.new "#{Message.api_root}/messages"
      WebMock.stub_request(:post, uri)
        .with(headers: { 'Http-Authorization' => Message.api_token })
        .to_return(status: 200, body: message_response)
    end

    context 'anonymous user' do
      before do
        message_create_request
        post :create, account_id: account.id, message: { name: 'hello' }
      end
      it 'redirects to account_message_path(@account, @message)' do
        expect(response.status).to be 302
        expect(response).to redirect_to(account_message_path(assigns(:account), assigns(:message)))
      end
      it 'assigns @account' do
        expect(assigns(:account)).to be_a_kind_of Account
        expect(assigns(:account).id).to eq account.id
        expect(assigns(:account).name).to eq account.name
      end
      it 'assigns @message' do
        expect(assigns(:message)).to be_a_kind_of Message
        expect(assigns(:message).id).to eq message.id
        expect(assigns(:message).name).to eq message.name
      end
      it 'makes the resource request' do
        body_str = "{\"message\":{\"name\":\"hello\",\"account_id\":\"account-0\"}}"
        expect(message_create_request.with(body: body_str)).to have_been_requested
      end
    end
  end

  describe "GET 'show'" do
    context 'anonymous user' do
      before do
        message_find_request
        get :show, id: message.id, account_id: account.id
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
      it 'assigns @message' do
        expect(assigns(:message)).to be_a_kind_of Message
        expect(assigns(:message).id).to eq message.id
        expect(assigns(:message).name).to eq message.name
      end
    end
  end

  describe "GET 'edit'" do
    context 'anonymous user' do
      before do
        message_find_request
        get :edit, id: message.id, account_id: account.id
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
      it 'assigns @message' do
        expect(assigns(:message)).to be_a_kind_of Message
        expect(assigns(:message).id).to eq message.id
        expect(assigns(:message).name).to eq message.name
      end
    end
  end

  describe "PATCH 'update'" do
    let(:message_update_request) do
      uri = Regexp.new "#{Message.api_root}/messages/#{message.id}"
      WebMock.stub_request(:patch, uri)
        .with(headers: { 'Http-Authorization' => Message.api_token })
        .to_return(status: 200, body: message_response)
    end

    context 'anonymous user' do
      before do
        message_find_request
        message_update_request
        patch :update, id: message.id, message: { name: 'hello' }, account_id: account.id
      end
      it 'redirects to account_message_path(@account, @message)' do
        expect(response.status).to be 302
        expect(response).to redirect_to(account_message_path(assigns(:account), assigns(:message)))
      end
      it 'assigns @account' do
        expect(assigns(:account)).to be_a_kind_of Account
        expect(assigns(:account).id).to eq account.id
        expect(assigns(:account).name).to eq account.name
      end
      it 'assigns @message' do
        expect(assigns(:message)).to be_a_kind_of Message
        expect(assigns(:message).id).to eq message.id
        expect(assigns(:message).name).to eq message.name
      end
      it 'makes the message update request' do
        expect(message_update_request).to have_been_requested
      end
      it 'makes the message find request' do
        expect(message_find_request).to have_been_requested
      end
      it 'makes the account find request' do
        expect(account_find_request).to have_been_requested
      end
    end
  end

  describe "DELETE 'destroy'" do
    let(:message_delete_request) do
      uri = Regexp.new "#{Message.api_root}/messages/#{message.id}"
      WebMock.stub_request(:delete, uri)
        .with(headers: { 'Http-Authorization' => Message.api_token })
        .to_return(status: 200, body: message_response)
    end

    context 'anonymous user' do
      before do
        message_find_request
        message_delete_request
        delete :destroy, id: message.id, account_id: account.id
      end
      it 'redirects to account_messages_path(@account)' do
        expect(response.status).to be 302
        expect(response).to redirect_to(account_messages_path(assigns(:account)))
      end
      it 'makes the message delete request' do
        expect(message_delete_request).to have_been_requested
      end
      it 'makes the account find request' do
        expect(account_find_request).to have_been_requested
      end
      it 'makes the message find request' do
        expect(message_find_request).to have_been_requested
      end
    end
  end
end
