class Handlebars
  def self.template(template_id)
    compiled_templates[template_id.to_s] ||= `Handlebars.compile(document.getElementById(#{template_id.to_s}).innerHTML)`
  end

  def self.compile(template_id, data)
    template(template_id).call(data.to_n)
  end

  def self.compile_and_render(template_id, data, container)
    html = Handlebars.compile(template_id, data)
    Document.find(container).html(html)
  end

  private

  def self.compiled_templates
    @compiled_templates ||= {}
  end
end
