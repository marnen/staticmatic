module StaticMatic::RescueMixin
  # Pass back an error template for the given exception
  def render_rescue_from_error(exception)
    rescue_template     = (exception.is_a?(StaticMatic::TemplateError)) ? "template" : "default"
      
    error_template_path = File.expand_path(File.dirname(__FILE__) + "/../templates/rescues/#{rescue_template}.haml")
    
    @scope.instance_variable_set("@exception", exception)
    
    render_template(error_template_path)
  end
end