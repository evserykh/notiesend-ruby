module Notisend
  class Client
    attr_reader :api_token

    def initialize(api_token)
      @api_token = api_token
    end

    def get(path, params = {})
      make_request(method: :get, path: path, params: params, headers: { 'Content-Type' => 'application/json' })
    end

    def post(path, params = {}, files = {})
      multipart = files.values.flatten.any?

      headers = {}
      body = nil
      if multipart
        files.each do |name, file_paths|
          params[name] = file_paths.map { |file_path| Faraday::UploadIO.new(file_path, 'application/octet-stream') }
        end
        body = params
      else
        headers = { 'Content-Type' => 'application/json' }
        body = params.to_json
      end

      make_request(method: :post, path: path, headers: headers, body: body, multipart: multipart)
    end

    private

    def schema
      'https'
    end

    def domain
      'api.notisend.ru'
    end

    def version
      'v1'
    end

    def prefix
      'email'
    end

    def base_url
      "#{schema}://#{domain}/#{version}/#{prefix}"
    end

    def build_connection
      Faraday.new(base_url) do |builder|
        builder.authorization('Bearer', api_token)
        yield(builder) if block_given?
        builder.adapter :net_http
      end
    end

    def make_request(options = {})
      method = options.fetch(:method)
      path = options.fetch(:path)
      headers = options.fetch(:headers, {})
      params = options.fetch(:params, {})
      body = options.fetch(:body, nil)
      multipart = options.fetch(:multipart, false)

      connection = build_connection { |builder| builder.request :multipart if multipart }

      response = connection.public_send(method, path) do |request|
        headers.each { |header, value| request.headers[header] = value }
        request.params = params
        request.body = body
      end

      Response.new(response)
    end
  end
end
