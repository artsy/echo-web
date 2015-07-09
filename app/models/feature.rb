class Feature
  include Braque::Model
  self.api_root = Rails.application.config_for(:echo_api)['url']
  self.api_token = Rails.application.config_for(:echo_api)['token']

  attribute :id
  attribute :name
  attribute :value
  attribute :account_id
  attribute :created_at
  attribute :updated_at
end
