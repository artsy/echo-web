class AccountsController < ApplicationController
  before_filter :set_pagination_params, only: :index
  before_filter :find_account, only: [:show, :edit, :update, :destroy]

  def index
    @accounts = Account.list page: @page, size: @size
  end

  def new
  end

  def create
    @account = Account.create params[:account]
    redirect_to account_path(@account), notice: t('flash.notice.success.create', class_name: 'Account')
  end

  def show
  end

  def edit
  end

  def update
    @account = @account.save params[:account]
    redirect_to account_path(id: @account.id), notice: t('flash.notice.success.update', class_name: 'Account')
  end

  def destroy
    @account.destroy
    redirect_to accounts_path, notice: t('flash.notice.success.delete', class_name: 'Account')
  end

  private

  def find_account
    @account = Account.find id: params[:id]
  end
end
