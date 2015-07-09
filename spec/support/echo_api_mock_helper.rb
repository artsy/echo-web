API_ROOT_JSON = {
  '_links' => {
    'self' => {
      'href' => "#{Account.api_root}"
    },
    'health' => {
      'href' => "#{Account.api_root}/health"
    },
    'accounts' => {
      'href' => "#{Account.api_root}/accounts{?page,size}",
      'templated' => true
    },
    'account' => {
      'href' => "#{Account.api_root}/accounts/{id}",
      'templated' => true
    },
    'features' => {
      'href' => "#{Feature.api_root}/features{?page,size,account_id}",
      'templated' => true
    },
    'feature' => {
      'href' => "#{Feature.api_root}/features/{id}",
      'templated' => true
    },
    'messages' => {
      'href' => "#{Message.api_root}/messages{?page,size,account_id}",
      'templated' => true
    },
    'message' => {
      'href' => "#{Message.api_root}/messages/{id}",
      'templated' => true
    },
    'routes' => {
      'href' => "#{Route.api_root}/routes{?page,size,account_id}",
      'templated' => true
    },
    'route' => {
      'href' => "#{Route.api_root}/routes/{id}",
      'templated' => true
    }
  }
}

def root_request
  WebMock.stub_request(:get, "#{Account.api_root}/")
    .with(headers: { 'Http-Authorization' => Account.api_token })
    .to_return(status: 200, body: API_ROOT_JSON)
end
