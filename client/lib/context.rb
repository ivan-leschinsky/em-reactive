class Context
  def self.[](key)
    data[key]
  end

  def self.[]=(key, value)
    data[key] = value
  end

  def self.data
    @data ||= {}
  end
end