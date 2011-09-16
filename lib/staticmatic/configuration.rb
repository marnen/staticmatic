module StaticMatic
  class Configuration
    attr_accessor :preview_server_port

    attr_accessor :preview_server_host
    
    attr_accessor :use_extensions_for_page_links
    attr_accessor :sass_options, :haml_options, :coffee_options
    attr_accessor :default_template_engine

    attr_accessor :reverse_ext_mappings
    
    def initialize
      self.preview_server_port = 3000
      self.preview_server_host = "localhost"
      self.use_extensions_for_page_links = true
      self.sass_options = {}
      self.haml_options = {}
      self.coffee_options = ''
      self.default_template_engine = 'haml'

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
