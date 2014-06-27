module ActiveRecord
  CLASS_METHODS = %w(find where order limit offset first last)
  INSTANCE_METHODS = %w(save update delete destroy reload)
  METHODS = CLASS_METHODS + INSTANCE_METHODS

  UknownAttribute = Class.new(StandardError)
end

require 'active_record/chain'
require 'active_record/base'
require 'active_record/chained_object'