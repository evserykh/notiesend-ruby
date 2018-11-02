module Notisend
  # Class for interaction with messages
  class Message < OpenStruct
    using BlankQuery

    class << self
      extend Forwardable

      def_delegators :Notisend, :client

      # Sends an email message
      def deliver(opts = {})
        options = OpenStruct.new(opts)
        params = params_from(options)
        response = client.post(path, params, attachments: options.attachments).parsed_body
        new(response)
      end

      # Gets a message by id
      def get(id:)
        response = client.get(path(id)).parsed_body
        new(response)
      end

      # Sends an email message using a template
      def deliver_template(template_id:, to:, params: {})
        url = "templates/#{template_id}/#{path}"
        response = client.post(url, to: to, params: params).parsed_body
        new(response)
      end

      private

      def path(*args)
        ['messages', args].flatten.join('/')
      end

      def params_from(options)
        { from_email: options.from_email, to: options.to, subject: options.subject }.tap do |hash|
          hash[:from_name] = options.from_name unless options.from_name.blank?
          hash[:text] = options.text unless options.text.blank?
          hash[:html] = options.html unless options.html.blank?
        end
      end
    end
  end
end
