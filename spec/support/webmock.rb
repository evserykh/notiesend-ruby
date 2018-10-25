Notisend.configure { |config| config.api_token = 'api-token' }

def read_fixture(name)
  File.read(File.expand_path("../fixtures/#{name}", __dir__))
end

def stub_list_get_all(query = {})
  stub_request(:get, 'https://api.notisend.ru/v1/email/lists')
    .with(
      headers: {
        'Authorization' => 'Bearer api-token',
        'Content-Type' => 'application/json'
      },
      query: query
    )
    .to_return(body: read_fixture('list_get_all.json'))
end

def stub_list_create(title)
  stub_request(:post, 'https://api.notisend.ru/v1/email/lists')
    .with(
      headers: {
        'Authorization' => 'Bearer api-token',
        'Content-Type' => 'application/json'
      },
      body: { title: title }.to_json
    )
    .to_return(body: read_fixture('list_create.json'))
end

def stub_list_get(id)
  stub_request(:get, "https://api.notisend.ru/v1/email/lists/#{id}")
    .with(
      headers: {
        'Authorization' => 'Bearer api-token',
        'Content-Type' => 'application/json'
      }
    )
    .to_return(body: read_fixture('list_get.json'))
end

def stub_parameter_get_all(list_id, query = {})
  stub_request(:get, "https://api.notisend.ru/v1/email/lists/#{list_id}/parameters")
    .with(
      headers: {
        'Authorization' => 'Bearer api-token',
        'Content-Type' => 'application/json'
      },
      query: query
    )
    .to_return(body: read_fixture('parameter_get_all.json'))
end

def stub_parameter_create(list_id, kind, title)
  stub_request(:post, "https://api.notisend.ru/v1/email/lists/#{list_id}/parameters")
    .with(
      body: { title: title, kind: kind }.to_json,
      headers: {
        'Authorization' => 'Bearer api-token',
        'Content-Type' => 'application/json'
      }
    )
    .to_return(body: read_fixture('parameter_create.json'))
end
