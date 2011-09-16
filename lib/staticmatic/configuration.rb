module StaticMatic
  class Configuration
    attr_accessor :preview_server_host
    attr_accessor :preview_server_port
    
    attr_accessor :use_extensions_for_page_links
    attr_accessor :default_template_engine

    attr_accessor :engine_options, :preview_engine_options
    attr_accessor :reverse_ext_mappings
    
    def initialize
      self.preview_server_host = "localhost"
      self.preview_server_port = 3000

      self.use_extensions_for_page_links = true
      self.default_template_engine = 'haml'

      self.preview_engine_options = {}
      self.engine_options = {}
      # TODO: discover a way of auto-detecting these. one can hope.
      self.reverse_ext_mappings = {
        'sass' => 'css',
        'scss' => 'css',
        'less' => 'css',

        'coffee' => 'js',

        'builder' => 'xml',
        'yajl' => 'json'
      }

      %w{
        creole erb haml liquid radius mab markdown md
        mediawiki mkd mw nokogiri rdoc rhtml textile wiki
      }.each do |ext|
        @reverse_ext_mappings[ext] = 'html'
      end
    end

  end
end
