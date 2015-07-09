module Accounts
  class FeaturesController < ApplicationController
    before_filter :find_account_by_account_id
    before_filter :find_feature, only: [:show, :edit, :update, :destroy]
    before_filter :set_pagination_params, only: :index

    def index
      @features = Feature.list account_id: @account.id, page: @page, size: @size
    end

    def new
    end

    def create
      @feature = Feature.create feature_params
      redirect_to account_feature_path @account, @feature
    end

    def show
    end

    def edit
    end

    def update
      @feature = @feature.save feature_params
      redirect_to account_feature_path @account, @feature
    end

    def destroy
      @feature.destroy
      redirect_to account_features_path @account
    end

    private

    def feature_params
      params[:feature].merge account_id: @account.id
    end

    def find_feature
      @feature = Feature.find id: params[:id], account_id: @account.id
    end
  end
end
