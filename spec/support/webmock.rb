Notisend.configure { |config| config.api_token = 'api-token' }

def stub_list_get_all(query = {})
  stub_request(:get, 'https://api.notisend.ru/v1/email/lists')
    .with(
      headers: {
        'Authorization' => 'Bearer api-token',
        'Content-Type' => 'application/json',
      },
      query: query
    )
    .to_return(body: File.read(File.expand_path('../fixtures/list_get_all.json', __dir__)))
end

def stub_list_create(title = 'New List')
  stub_request(:post, 'https://api.notisend.ru/v1/email/lists')
    .with(
      headers: {
        'Authorization' => 'Bearer api-token',
        'Content-Type' => 'application/json',
      },
      body: { title: title }.to_json
    )
    .to_return(body: File.read(File.expand_path('../fixtures/list_create.json', __dir__)))
end

def stub_list_get(id = 1)
  stub_request(:get, "https://api.notisend.ru/v1/email/lists/#{id}")
    .with(
      headers: {
        'Authorization' => 'Bearer api-token',
        'Content-Type' => 'application/json',
      }
    )
    .to_return(body: File.read(File.expand_path('../fixtures/list_get.json', __dir__)))
end
