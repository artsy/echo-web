module Accounts
  class RoutesController < ApplicationController
    before_filter :find_account_by_account_id
    before_filter :find_route, only: [:show, :edit, :update, :destroy]
    before_filter :set_pagination_params, only: :index

    def index
      @routes = Route.list account_id: @account.id, page: @page, size: @size
    end

    def new
    end

    def create
      @route = Route.create route_params
      redirect_to account_route_path(@account, @route), notice: t('flash.notice.success.create', class_name: 'Route')
    end

    def show
    end

    def edit
    end

    def update
      @route = @route.save route_params
      redirect_to account_route_path(@account, @route), notice: t('flash.notice.success.update', class_name: 'Route')
    end

    def destroy
      @route.destroy
      redirect_to account_routes_path(@account), notice: t('flash.notice.success.update', class_name: 'Route')
    end

    private

    def route_params
      params[:route].merge account_id: @account.id
    end

    def find_route
      @route = Route.find id: params[:id], account_id: @account.id
    end
  end
end
