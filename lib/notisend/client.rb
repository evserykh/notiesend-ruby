module Notisend
  # Requests helper
  class Client
    attr_reader :api_token

    def initialize(api_token)
      @api_token = api_token
    end

    def get(path, params = {})
      headers = prepare_headers
      make_request(method: :get, path: path, params: params, headers: headers)
    end

    def post(path, params = {}, files = {})
      body = prepare_body(params, files)
      headers = prepare_headers(files)
      make_request(method: :post, path: path, headers: headers, body: body, multipart: multipart?(files))
    end

    def patch(path, params = {}, files = {})
      body = prepare_body(params, files)
      headers = prepare_headers(files)
      make_request(method: :patch, path: path, headers: headers, body: body, multipart: multipart?(files))
    end

    def delete(path, params = {})
      headers = prepare_headers
      make_request(method: :delete, path: path, params: params, headers: headers)
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

    def multipart?(files)
      files.values.flatten.any?
    end

    def prepare_body(params, files)
      return params.to_json unless multipart?(files)

      files.each_with_object(params) { |(name, value), result| result[name] = value }
    end

    def prepare_headers(files = {})
      return { 'Content-Type' => 'application/json' } unless multipart?(files)

      {}
    end

    def user_agent
      "NotisendRuby #{VERSION}"
    end

    def make_request(options = {}) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      method = options.fetch(:method)
      path = options.fetch(:path)
      headers = options.fetch(:headers, {})
      params = options.fetch(:params, {})
      body = options.fetch(:body, nil)
      multipart = options.fetch(:multipart, false)

      connection = build_connection { |builder| builder.request :multipart if multipart }

      response = connection.public_send(method, path) do |request|
        headers['User-Agent'] = user_agent
        headers.each { |header, value| request.headers[header] = value }
        request.params = params
        request.body = body
      end

      Response.new(response)
    end
  end
end
