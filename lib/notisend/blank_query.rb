module Notisend
  # blank? method support
  module BlankQuery
    refine NilClass do
      def blank?
        true
      end
    end

    refine String do
      def blank?
        strip.length.zero?
      end
    end
  end
end
