
module StaticMatic
  module Helpers
    module RenderHelper
      self.extend self
      
      def content_hash
        @content_hash ||= {}
      end
      
      def yield_for(index)
        self.content_hash[index.to_sym] || ""
      end
      
      def content_for(index,&block)
        content_hash[:sidebar] = capture_haml &block
      end
      
      # Include a partial template
      def partial(name, options = {})
        @staticmatic.generate_partial(name, options)
      end
    end
  end
end
