Notisend.configure { |config| config.api_token = 'api-token' }

def read_fixture(name)
  File.read(File.expand_path("../fixtures/#{name}", __dir__))
end

def common_headers
  {
    'Authorization' => 'Bearer api-token',
    'Content-Type' => 'application/json',
    'User-Agent' => "NotisendRuby #{Notisend::VERSION}"
  }
end

def stub_list_get_all(query = {})
  stub_request(:get, 'https://api.notisend.ru/v1/email/lists')
    .with(
      headers: common_headers,
      query: query
    )
    .to_return(body: read_fixture('list_get_all.json'))
end

def stub_list_create(title)
  stub_request(:post, 'https://api.notisend.ru/v1/email/lists')
    .with(
      headers: common_headers,
      body: { title: title }.to_json
    )
    .to_return(body: read_fixture('list_create.json'))
end

def stub_list_get(id)
  stub_request(:get, "https://api.notisend.ru/v1/email/lists/#{id}")
    .with(
      headers: common_headers
    )
    .to_return(body: read_fixture('list_get.json'))
end

def stub_parameter_get_all(list_id, query = {})
  stub_request(:get, "https://api.notisend.ru/v1/email/lists/#{list_id}/parameters")
    .with(
      headers: common_headers,
      query: query
    )
    .to_return(body: read_fixture('parameter_get_all.json'))
end

def stub_parameter_create(list_id, kind, title)
  stub_request(:post, "https://api.notisend.ru/v1/email/lists/#{list_id}/parameters")
    .with(
      body: { title: title, kind: kind }.to_json,
      headers: common_headers
    )
    .to_return(body: read_fixture('parameter_create.json'))
end

def stub_recipient_get_all(list_id, query = {})
  stub_request(:get, "https://api.notisend.ru/v1/email/lists/#{list_id}/recipients")
    .with(
      headers: common_headers,
      query: query
    )
    .to_return(body: read_fixture('recipient_get_all.json'))
end

def stub_recipient_create(list_id, email, values = [])
  stub_request(:post, "https://api.notisend.ru/v1/email/lists/#{list_id}/recipients")
    .with(
      body: { email: email, values: values }.to_json,
      headers: common_headers
    )
    .to_return(body: read_fixture('recipient_create.json'))
end

def stub_recipient_update(id, list_id, email, values = [])
  stub_request(:patch, "https://api.notisend.ru/v1/email/lists/#{list_id}/recipients/#{id}")
    .with(
      body: { email: email, values: values }.to_json,
      headers: common_headers
    )
    .to_return(body: read_fixture('recipient_update.json'))
end

def stub_recipient_import(list_id, recipients)
  stub_request(:post, "https://api.notisend.ru/v1/email/lists/#{list_id}/recipients/imports")
    .with(
      body: { recipients: recipients }.to_json,
      headers: common_headers
    )
    .to_return(body: read_fixture('recipient_import.json'))
end
