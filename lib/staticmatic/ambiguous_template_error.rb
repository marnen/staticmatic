class StaticMatic::AmbiguousTemplateError < StandardError
  attr_reader :template_name
  
  def initialize(template_name, ambiguous_templates)
    @template_name = template_name
    @ambiguous_templates = ambiguous_templates
  end
  
  def message
<<-MESSAGE
Ambiguous request when searching for a template for filename `#{@template_name}`:
There is more than one type of template available for rendering.

Templates causing the ambiguity:
#{@ambiguous_templates.join "\n"}
MESSAGE
  end

end
