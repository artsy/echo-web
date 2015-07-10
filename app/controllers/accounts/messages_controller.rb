module Accounts
  class MessagesController < ApplicationController
    before_filter :find_account_by_account_id
    before_filter :find_message, only: [:show, :edit, :update, :destroy]
    before_filter :set_pagination_params, only: :index

    def index
      @messages = Message.list account_id: @account.id, page: @page, size: @size
    end

    def new
    end

    def create
      @message = Message.create message_params
      redirect_to account_message_path(@account, @message), notice: t('flash.notice.success.create', class_name: 'Message')
    end

    def show
    end

    def edit
    end

    def update
      @message = @message.save message_params
      redirect_to account_message_path(@account, @message), notice: t('flash.notice.success.update', class_name: 'Message')
    end

    def destroy
      @message.destroy
      redirect_to account_messages_path(@account), notice: t('flash.notice.success.update', class_name: 'Message')
    end

    private

    def message_params
      params[:message].merge account_id: @account.id
    end

    def find_message
      @message = Message.find id: params[:id], account_id: @account.id
    end
  end
end
