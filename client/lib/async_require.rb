module Kernel
  def async_require(path, &block)
    HTTP.get("/assets/#{path}.js", &block)
  end
end