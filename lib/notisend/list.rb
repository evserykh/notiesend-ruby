module Notisend
  # Class for interaction with lists
  class List < OpenStruct
    class << self
      extend Forwardable

      def_delegators :Notisend, :client

      # Gets all lists
      def get_all(params: {})
        response = client.get(path, params).parsed_body.tap do |resp|
          resp['collection'] = resp['collection'].map { |attributes| new(attributes) }
        end
        OpenStruct.new(response)
      end

      # Creates a new list
      def create(title:)
        params = { title: title }
        response = client.post(path, params).parsed_body
        new(response)
      end

      # Gets a list by id
      def get(id:)
        response = client.get(path(id)).parsed_body
        new(response)
      end

      private

      def path(*args)
        ['lists', args].flatten.join('/')
      end
    end
  end
end
