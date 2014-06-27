module ActiveRecord
  module Chain

    module InstanceMethods
      def method_missing(method_name, *args)
        if self.class.column_names.include?(method_name.to_s)
          @attrs[method_name.to_sym]
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        self.class.column_names.include?(method_name.to_s) || super
      end
    end

    module ClassMethods
      def method_missing(method_name, *args)
        if ActiveRecord::CLASS_METHODS.include?(method_name.to_s)
          ActiveRecord::ChainedObject.with(self, method_name, args)
        else
          super
        end
      end
    end

    def self.included(klass)
      klass.send(:include, InstanceMethods)
      klass.send(:extend,  ClassMethods)
    end

  end
end