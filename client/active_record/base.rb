require 'json'

module ActiveRecord
  class Base

    include ActiveRecord::Chain

    attr_reader :attrs

    def initialize(attrs = {})
      @attrs = {}
      attrs.each do |key, value|
        if self.class.column_names.include?(key.to_s)
          @attrs[key.to_sym] = value
        else
          raise ActiveRecord::UknownAttribute, "Unknown attribute '#{key}'"
        end
      end
    end

    def self.inherited(klass)
      subclasses << klass
    end

    def self.column_names
      @column_names ||= []
    end

    def self.column_names=(column_names)
      @column_names = column_names
    end

    def self.subclasses
      @subclasses ||= []
    end

    def self.subclasses=(subclasses)
      @subclasses = subclasses
    end

    def inspect
      "#<#{self.class.name} " + @attrs.map { |k, v| "#{k}: #{v.inspect}" }.join(", ") + ">"
    end
  end
end
