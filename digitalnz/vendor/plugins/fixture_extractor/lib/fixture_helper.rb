module FixtureHelper
  def self.included(base)
    base.send(:include, InstanceMethods)
  end

  class FixtureMappings
    include Singleton
    attr_reader :mappings

    def self.map_fixtures(&block)
      yield(FixtureMappings.instance)
      return FixtureMappings.instance
    end

    # define a callback to lookup a model by a +model_identifier+ string.  See
    # FixtureMappings::map_fixtures
    def self.to_lookup(model_class, &block)
      (@@model_lookups ||= {})[model_class] = block
    end
    
    def self.lookup_model(model_class, model_identifier)
      lookup = @@model_lookups[model_class] || @@model_lookups[:default]
      return lookup.call(model_class, model_identifier) unless (lookup.nil?)
    end
    
    def initialize
      @mappings = Hash.new { |hash, key| hash[key] = Hash.new }
    end
    
    def method_missing(model_name, *args, &block)
      model_class = model_name.to_s.classify.constantize
      model_identifier = args.shift

      begin
        if (model_identifier.is_a?(model_class))
          model = model_identifier
        elsif (model_identifier.is_a?(Numeric))
          model = model_class.find(model_identifier)
        else
          model = self.class.lookup_model(model_class, model_identifier)
        end
      rescue
        raise "error mapping model '#{model_name}:#{model_identifier}': " + $!.message
      end

      raise "could not map model '#{model_name}:#{model_identifier}'" if (model.nil?)
      
      args.each do |mapping_name|
        @mappings[model_class][mapping_name] = model
      end
    end
  end
  
  module InstanceMethods
    def fixture(model_class, fixture_name)
      fixture = FixtureMappings.instance.mappings[model_class][fixture_name]
      if (fixture.nil?)
        raise "unable to find fixture #{model_class}:#{fixture_name}" 
      end

      fixture.reload
      return fixture
    end
  end
end
