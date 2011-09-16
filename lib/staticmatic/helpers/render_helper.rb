
module StaticMatic
  module Helpers
    module RenderHelper
      self.extend self
      
      # Include a partial template
      def partial(name, options = {})
        name = @staticmatic.ensure_extension(name)
        @staticmatic.generate_partial(name, options)
      end
    end
  end
end
