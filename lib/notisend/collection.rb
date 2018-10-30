module Notisend
  # Class for wrapping collection response
  class Collection < OpenStruct
    def initialize(response, item_class)
      data = response.tap do |resp|
        resp['collection'] = resp['collection'].map { |attributes| item_class.new(attributes) }
      end
      super(data)
    end
  end
end
