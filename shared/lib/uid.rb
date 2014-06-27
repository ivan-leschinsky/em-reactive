# Class for generating random string (UIDs)
#
# @example
#   UID.generate(10)
#   # => "jjdneaazfb"
#
class UID
  # Generates random string
  #
  # @param length [String] length of string to generate
  #
  # @return String
  #
  def self.generate(length = 10)
    Array.new(length) { ("a".."z").to_a.shuffle.first }.join
  end
end
