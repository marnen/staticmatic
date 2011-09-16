module StaticMatic
  class Configuration
    attr_accessor :preview_server_port

    attr_accessor :preview_server_host
    
    attr_accessor :use_extensions_for_page_links
    attr_accessor :sass_options, :haml_options, :coffee_options
    attr_accessor :default_template_engine
    
    def initialize
      self.preview_server_port = 3000
      self.preview_server_host = "localhost"
      self.use_extensions_for_page_links = true
      self.sass_options = {}
      self.haml_options = {}
      self.coffee_options = ''
      self.default_template_engine = 'haml'
    end
  end
end
