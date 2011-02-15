
module StaticMatic
  module Helpers
    module AssetsHelper
      self.extend self
      
      # Generates links to all stylesheets in the source directory
      # = stylesheets
      # or specific stylesheets in a specific order
      # = stylesheets :reset, :application
      # Can also pass options hash in at the end so you can specify :media => :print
      def stylesheets(*params)
        options = if params.last.is_a? Hash; params.pop else {} end
        
        options[:media] = 'all' unless options.has_key?(:media)
        options[:rel] = 'stylesheet'; options[:type] = 'text/css'

        relative_path = current_page_relative_path

        output = ""
        if params.length == 0
          # no specific files requested so include all in no particular order
          stylesheet_dir = File.join(@staticmatic.src_dir, 'stylesheets')
          stylesheet_directories = Dir[File.join(stylesheet_dir, '**','*.{sass,scss}')]
          
          # Bit of a hack here - adds any stylesheets that exist in the site/ dir that haven't been generated from source sass
          Dir[File.join(@staticmatic.site_dir, 'stylesheets', '*.css')].each do |filename|
            search_filename = File.basename(filename).chomp(File.extname(filename))
            puts search_filename
            already_included = false
            stylesheet_directories.each do |path|
              if File.basename(path).include?(search_filename)
                already_included = true
                break
              end
            end
            
            stylesheet_directories << filename unless already_included
          end

          stylesheet_directories.each do |path|
            
            filename_without_extension = File.basename(path).chomp(File.extname(path))
            
            if !filename_without_extension.match(/^\_/)
              
              path = path.gsub(/#{@staticmatic.src_dir}/, "").
                          gsub(/#{@staticmatic.site_dir}/, "").
                          gsub(/#{filename_without_extension}\.(sass|scss|css)/, "")
                          
              src = File.join(relative_path, path, "#{filename_without_extension}.css")
              src = qstring(src, options[:qstring])
              options[:href] = src
              options.delete(:qstring)
              output << tag(:link, options)
            end
          end
        else
          #specific files requested and in a specific order
          params.each do |file|
            if File.exist?(File.join(@staticmatic.src_dir, 'stylesheets', "#{file}.sass")) ||
               File.exist?(File.join(@staticmatic.src_dir, 'stylesheets', "#{file}.scss")) || 
               File.exist?(File.join(@staticmatic.site_dir, 'stylesheets', "#{file}.css"))
              src = File.join(relative_path, "stylesheets", "#{file}.css")
              src = qstring(src, options[:qstring])
              options[:href] = src
              options.delete(:qstring)
              output << tag(:link, options)
            end
          end
        end
        
        output
      end
      
      # Generate javascript source tags for the specified files
      #
      # javascripts('test')   ->   <script language="javascript" src="javascripts/test.js"></script>
      #    
      def javascripts(*files)
        options = if params.last.is_a? Hash; params.pop else {} end
        relative_path = current_page_relative_path

        output = ""
        files.each do |file|
          file_str = file.to_s
          src = file_str.match(%r{^((\.\.?)?/|https?://)}) ? file_str : "#{relative_path}javascripts/#{file_str}.js"
          src = qstring(src, options[:qstring])
          output << tag(:script, :language => 'javascript', :src => src, :type => "text/javascript") { "" }
        end
        output
      end

      # Generates an image tag always relative to the current page unless absolute path or http url specified.
      # 
      # img('test_image.gif')   ->   <img src="/images/test_image.gif" alt="Test image"/>
      # img('contact/test_image.gif')   ->   <img src="/images/contact/test_image.gif" alt="Test image"/>
      # img('http://localhost/test_image.gif')   ->   <img src="http://localhost/test_image.gif" alt="Test image"/>
      def img(name, options = {})
        options[:src] = name.match(%r{^((\.\.?)?/|https?://)}) ? name : "#{current_page_relative_path}images/#{name}"
        options[:alt] ||= name.split('/').last.split('.').first.capitalize.gsub(/_|-/, ' ')
        tag :img, options
      end
      
      # Prepares a query string based on the given qstr.
      # If qstr is true, it generates a query string based on the current time.
      # If qstr is a string, it uses it as the query string itself.
      # 
      def qstring(src,qstr)
        src += '?v=' + Time.now.to_i.to_s if qstr == true
        src += '?v=' + qstr if qstr.is_a? String
        src
      end
    end
  end
end
