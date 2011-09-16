module StaticMatic::BuildMixin
    
  def build
    build_css
    build_js
    build_html
    copy_images
  end
    
  # Build HTML from the source files
  def build_html
    src_file_paths('haml').each do |path|
      file_dir, template = source_template_from_path(path.sub(/^#{@src_dir}/, ''))
      save_page(File.join(file_dir, template), generate_html_with_layout(template, file_dir))
    end
  end

  # Build CSS from the source files
  def build_css
    src_file_paths('sass','scss').each do |path|
      file_dir, template = source_template_from_path(path.sub(/^#{@src_dir}/, ''))
      
      if !template.match(/(^|\/)\_/)
        save_stylesheet(File.join(file_dir, template), generate_css(template, file_dir))
      end
    end
  end
  
  def build_js
    coffee_found = ENV['PATH'].split(':').inject(false) { |found, folder| found |= File.exists?("#{folder}/coffee") }
    if coffee_found
      src_file_paths('coffee').each do |path|
        file_dir, template = source_template_from_path(path.sub(/^#{@src_dir}/, ''))
        save_javascript(File.join(file_dir, template), generate_js(template, file_dir))
      end
    end
    # copy normal javascript files over
    src_file_paths('js').each do |path|
      file_dir, template = source_template_from_path(path.sub(/^#{@src_dir}/, ''))
      copy_file(path, File.join(@site_dir, file_dir, "#{template}.js"))
    end
  end
  
  def copy_images
    src_file_paths(*%w{gif jpg jpef png tiff}).each do |path|
      file_dir, file_name = File.split(path.sub(/^#{@src_dir}/, ''))
      copy_file(path, File.join(@site_dir, file_dir, file_name))
    end
  end

  def copy_file(from, to)
    FileUtils.mkdir_p(File.dirname(to))
    FileUtils.cp(from, to)
  end

  def save_page(filename, content)
    generate_site_file(filename, 'html', content)
  end

  def save_stylesheet(filename, content)
    generate_site_file(filename, 'css', content)
  end

  def save_javascript(filename, content)
    generate_site_file(filename, 'js', content)
  end

  def generate_site_file(filename, extension, content)
    path = File.join(@site_dir,"#{filename}.#{extension}")
    FileUtils.mkdir_p(File.dirname(path))
    File.open(path, 'w+') do |f|
      f << content
    end
    
    puts "created #{path}"
  end

  # Returns a dir and raw template name from a source file path:
  # source_template_from_path("/path/to/site/src/stylesheets/application.sass")  -> [ "/path/to/site/src/stylesheets", "application" ]
  def source_template_from_path(path)
    file_dir, file_name = File.split(path)
    file_name.chomp!(File.extname(file_name))
    [ file_dir, file_name ]
  end

end