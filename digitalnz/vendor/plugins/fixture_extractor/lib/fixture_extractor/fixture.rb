require 'set'
require 'base64'
require 'yaml/encoding'

module FixtureExtractor
  class Fixture
  
    @@fixtures = Hash.new
  
    def Fixture.new_instance(model)
      begin
        return ("FixtureExtractor::" + model.class.name + "Fixture").constantize.new(model)
      rescue
        return Fixture.new(model)
      end
    end
  
    def Fixture.collect_table(table)
      class_name = table.to_s.singularize.camelcase
      table_class = Kernel.const_get(class_name)
  
      table_class.find(:all).each do |record|
        Fixture.new_instance(record).collect_fixture
      end
    end
  
    def Fixture.fixtures
      @@fixtures
    end
  
    attr_reader :model
  
    def initialize(model)
      @model = model
    end
  
    def to_yaml
      yaml = "#{name}:\n"
  
      model.class.columns.each do |column|
        yaml += Fixture.yaml_field(@model, column)
      end
  
      return "#{yaml}\n"
    end
  
    def name
      return "#{model.class.table_name.singularize}_#{model.id.to_s}"
    end

    def table_name
      return model.class.table_name.to_sym
    end
    
    def collect_fixture(options = {})
      @@fixtures[table_name] ||= SortedSet.new
  
      if (@@fixtures[table_name].include?(self))
        return
      end
  
      before_collect(options)
      
      @@fixtures[table_name] << self
      collect_associations(options) unless (options[:ignore] == :all)

      after_collect(options)
    end
  
    def before_collect(options)
    end
        
    def after_collect(options)
    end
  
    def ignore_associations
      []
    end
  
    def collect_associations(options = {})
      ignore_associations = options[:ignore] || self.ignore_associations
      ignore_associations = [ ignore_associations ] unless (ignore_associations.is_a?(Array))
  
      model.class.reflections.each_value do |reflection|
        next if (ignore_associations.include?(reflection.name))
  
        if (reflection.macro == :belongs_to)
          obj = @model.send(reflection.name)
          Fixture.new_instance(obj).collect_fixture if (!obj.nil?)
        elsif (reflection.macro == :has_many)
          @model.send(reflection.name).each do |obj|
            Fixture.new_instance(obj).collect_fixture
          end
        elsif (reflection.macro == :has_and_belongs_to_many)
          join_table = reflection.options[:join_table]
  
          @model.send(reflection.name).each do |obj|
            JoinTableFixture.new_instance(@model, obj, reflection).collect_fixture
          end
        end
      end
    end
  
    def <=>(other)
      raise "type mismatch!" unless (model.kind_of?(other.model.class))
      return model.id <=> other.model.id
    end
  
    def eql?(other)
      return model.eql?(other.model)
    end
  
    def hash
      return model.hash
    end
  
    protected
      def Fixture.yamlize_name(name)
        ret = name.gsub(/[#\s(),\\\/-]+/, "_").gsub(/_+/, "_").gsub(/_+$/, "").downcase
        raise "invalid fixture name '#{ret}': name cannot begin with a number" if (ret =~ /^\d+/)
        return ret
      end
  
      def Fixture.yaml_field(obj, column)
        field = column.name
        val = obj.send(field.to_sym)
  
        return "" if (val.nil?)
  
        if (column.type == :binary)
          val = "!!binary \"\\\n#{Base64.encode64(val).rstrip}\""
        else
          if (val == true or val == false)
            val = val ? "1" : "0"
          end
  
          val = "\"#{YAML::escape(val.to_s)}\""
        end
  
        return "  #{field}: #{val}\n"
      end
  end
end
