class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def set_pagination_params
    @page = (params[:page] || 1).to_i
    @size = (params[:size] || 10).to_i
  end

  def find_account_by_account_id
    @account = Account.find id: params[:account_id]
  end
end
