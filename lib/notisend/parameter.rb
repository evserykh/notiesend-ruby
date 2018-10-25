module Notisend
  # Class for interaction with list parameters
  class Parameter < OpenStruct
    class << self
      extend Forwardable

      def_delegators :Notisend, :client

      # Gets all parameters for a list
      def get_all(list_id:, params: {})
        response = client.get(path(list_id), params).parsed_body.tap do |resp|
          resp['collection'] = resp['collection'].map { |attributes| new(attributes) }
        end
        OpenStruct.new(response)
      end

      # Creates a new parameter for a list
      def create(title:, kind:, list_id:)
        params = { title: title, kind: kind }
        response = client.post(path(list_id), params).parsed_body
        new(response)
      end

      private

      def path(list_id, *args)
        ['lists', list_id, 'parameters', args].flatten.join('/')
      end
    end
  end
end
