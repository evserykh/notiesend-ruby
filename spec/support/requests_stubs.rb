Notisend.configure { |config| config.api_token = 'api-token' }

def read_fixture(name)
  File.read(File.expand_path("../fixtures/#{name}", __dir__))
end

def url(path)
  "https://api.notisend.ru/v1/email/#{path}"
end

def common_headers
  {
    'Authorization' => 'Bearer api-token',
    'Content-Type' => 'application/json',
    'User-Agent' => "NotisendRuby #{Notisend::VERSION}"
  }
end

def stub_list_get_all(query = {})
  stub_request(:get, url('lists'))
    .with(
      headers: common_headers,
      query: query
    )
    .to_return(body: read_fixture('list_get_all.json'))
end

def stub_list_create(title)
  stub_request(:post, url('lists'))
    .with(
      headers: common_headers,
      body: { title: title }.to_json
    )
    .to_return(body: read_fixture('list_create.json'))
end

def stub_list_get(id)
  stub_request(:get, url("lists/#{id}"))
    .with(
      headers: common_headers
    )
    .to_return(body: read_fixture('list_get.json'))
end

def stub_parameter_get_all(list_id, query = {})
  stub_request(:get, url("lists/#{list_id}/parameters"))
    .with(
      headers: common_headers,
      query: query
    )
    .to_return(body: read_fixture('parameter_get_all.json'))
end

def stub_parameter_create(list_id, kind, title)
  stub_request(:post, url("lists/#{list_id}/parameters"))
    .with(
      body: { title: title, kind: kind }.to_json,
      headers: common_headers
    )
    .to_return(body: read_fixture('parameter_create.json'))
end

def stub_recipient_get_all(list_id, query = {})
  stub_request(:get, url("lists/#{list_id}/recipients"))
    .with(
      headers: common_headers,
      query: query
    )
    .to_return(body: read_fixture('recipient_get_all.json'))
end

def stub_recipient_create(list_id, email, values = [])
  stub_request(:post, url("lists/#{list_id}/recipients"))
    .with(
      body: { email: email, values: values }.to_json,
      headers: common_headers
    )
    .to_return(body: read_fixture('recipient_create.json'))
end

def stub_recipient_update(id, list_id, email, values = [])
  stub_request(:patch, url("lists/#{list_id}/recipients/#{id}"))
    .with(
      body: { email: email, values: values }.to_json,
      headers: common_headers
    )
    .to_return(body: read_fixture('recipient_update.json'))
end

def stub_recipient_import(list_id, recipients)
  stub_request(:post, url("lists/#{list_id}/recipients/imports"))
    .with(
      body: { recipients: recipients }.to_json,
      headers: common_headers
    )
    .to_return(body: read_fixture('recipient_import.json'))
end

def stub_recipient_delete(list_id, id)
  stub_request(:delete, url("lists/#{list_id}/recipients/#{id}"))
    .with(
      headers: common_headers
    )
    .to_return(body: '', status: 204)
end

def stub_message_get(id)
  stub_request(:get, url("messages/#{id}"))
    .with(
      headers: common_headers
    )
    .to_return(body: read_fixture('message_get.json'))
end

def stub_message_deliver_template(template_id, to, params = {})
  stub_request(:post, url("templates/#{template_id}/messages"))
    .with(
      body: { to: to, params: params },
      headers: common_headers
    )
    .to_return(body: read_fixture('message_deliver_template.json'))
end

# rubocop: disable Metrics/AbcSize, Metrics/MethodLength
def stub_message_deliver(options, files = [])
  if files.any?
    headers = common_headers.reject { |k, _| k == 'Content-Type' }
    stub_request(:post, url('messages'))
      .with(headers: headers) do |request|
        params_part = options.keys.map { |key| %((?=.*Content-Disposition: form-data; name="#{key}")) }
        files_part = files.map do |path|
          name = File.basename(path)
          %((?=.*Content-Disposition: form-data; name="attachments[]"; filename="#{name}"))
        end
        regexp_string = [params_part, files_part].flatten.join.gsub('[', '\[').gsub(']', '\]')
        request.body =~ Regexp.new(regexp_string, Regexp::MULTILINE)
      end
      .to_return(body: read_fixture('message_deliver.json'))
  else
    stub_request(:post, url('messages'))
      .with(
        headers: common_headers,
        body: options.to_json
      )
      .to_return(body: read_fixture('message_deliver.json'))
  end
end
# rubocop: enable Metrics/AbcSize, Metrics/MethodLength
