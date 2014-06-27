class Handlebars
  def self.template(template_id)
    compiled_templates[template_id] ||= `Handlebars.compile(document.getElementById(#{template_id}).innerHTML)`
  end

  def self.compile(template_id, data)
    template(template_id).call(data.to_n)
  end

  private

  def self.compiled_templates
    @compiled_templates ||= {}
  end
end
