module StaticMatic::RenderMixin
  
  # clear all scope variables except @staticmatic
  def clear_template_variables!
    
    @scope.instance_variables.each do |var|
      @scope.instance_variable_set(var, nil) unless var == '@staticmatic' || var == :@staticmatic
    end
  end
  
  # Generate html from source file:
  # render_template("index.haml")
  def render_template(file_path)
    @current_file_stack.push(file_path)
    begin
      tilt_template(file_path)
    rescue StaticMatic::TemplateError => e
      raise e # re-raise inline errors
    rescue Exception => e
      raise StaticMatic::TemplateError.new(file_path, e)
    ensure
      @current_file_stack.pop
    end
  end

  def render_template_with_layout(file_path)
    @current_file_stack.push(file_path)
    begin 
      rendered_file_content = render_template(file_path)
      tilt_template_with_layout(fetch_layout_path) { rendered_file_content }
    rescue Exception => e
      render_rescue_from_error(e)
    ensure
      @current_file_stack.pop
    end
  end

  def generate_partial(name, options = {})
    partial_dir, partial_name, partial_ext = expand_path name
    partial_name = "_#{partial_name}"

    context = File.join File.dirname(self.current_file), partial_dir
    partial_path = determine_template_path(partial_name, partial_ext, context)

    unless partial_path && File.exists?(partial_path)
      # partial not found in the current file's directory, so try the _partials folder
      context = File.join @src_dir, '_partials', partial_dir
      partial_name.sub! /^_/, ''
      partial_path = determine_template_path(partial_name, partial_ext, context)
    end
  
    if partial_path && File.exists?(partial_path)
      return render_template partial_path
    else
      raise StaticMatic::Error.new("", name, "Partial not found")
    end
  end

  def fetch_layout_path(dir = nil)
    layout_path = File.join(@src_dir, "_layouts")
    declared_layout_name = @scope.instance_variable_get("@layout")

    if declared_layout_name
      path = determine_template_path declared_layout_name, '', layout_path
      unless path
        error_path = File.join(layout_path, declared_layout_name)
        raise StaticMatic::Error.new("", error_path, "Layout not found")
      end
    end

    if dir
      dir_layout_name = dir.split("/")[1]
      path ||= determine_template_path dir_layout_name, '', layout_path
    end
    path ||= determine_template_path @default_layout_name, '', layout_path

    unless path
      error_path = File.join(layout_path, @default_layout_name)
      raise StaticMatic::Error.new("", error_path, "No default layout could be found")
    end

    return path
  end

  private

  # TODO: more code reuse. needs some ruby &block and yield sorcery.
  def tilt_template(file_path)
    options = get_engine_options(file_path)
    Tilt.new(file_path, options).render(@scope)
  end

  def tilt_template_with_layout(file_path)
    options = get_engine_options(file_path)
    Tilt.new(file_path, options).render(@scope) { yield }
  end

  def get_engine_options(file_path)
    ext = File.extname(file_path).sub(/^\./, '')
    options = configuration.engine_options[ext] || {}
    preview_options = configuration.preview_engine_options[ext] || {}

    if @mode == :preview
      options.merge preview_options
    else
      options
    end
  end

end