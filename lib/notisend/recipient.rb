module Notisend
  # Class for interaction with list recipients
  class Recipient < OpenStruct
    class << self
      extend Forwardable

      def_delegators :Notisend, :client

      # Gets all recipients for a list
      def get_all(list_id:, params: {})
        response = client.get(path(list_id), params).parsed_body
        Collection.new(response, self)
      end

      # Creates a new recipient for a list
      def create(email:, list_id:, values: [])
        params = { email: email, values: values }
        response = client.post(path(list_id), params).parsed_body
        new(response)
      end

      # Updates a recipient
      def update(id:, list_id:, email: nil, values: [])
        params = {}.tap do |hash|
          hash[:email] = email if email
          hash[:values] = values
        end
        response = client.patch(path(list_id, id), params).parsed_body
        new(response)
      end

      # Imports a bunch of recipients
      def import(list_id:, recipients:)
        params = { recipients: recipients }
        response = client.post(path(list_id, 'imports'), params).parsed_body
        new(response)
      end

      private

      def path(list_id, *args)
        ['lists', list_id, 'recipients', args].flatten.join('/')
      end
    end
  end
end
