module FixtureExtractor
  class JoinTableFixture < Fixture
  
    def JoinTableFixture.new_instance(model, association, reflection)
      join_table = reflection.options[:join_table]
      begin
        return Kernel.const_get(join_table + "Fixture").new(model, association, reflection)
      rescue
        return JoinTableFixture.new(model, association, reflection)
      end
    end
  
    attr_reader :reflection
    attr_reader :association
  
    def initialize(model, association, reflection)
      @model = model
      @association = association
      @reflection = reflection
    end
  
    def join_table
      return @reflection.options[:join_table]
    end
  
    def collect_fixture
      @@fixtures[join_table.to_sym] ||= SortedSet.new
  
      return if (@@fixtures[join_table.to_sym].include?(self))
      @@fixtures[join_table.to_sym] << self
  
      Fixture.new_instance(association).collect_fixture
    end
  
  
    def to_yaml
      yaml = "#{name}:\n"
      yaml += "  #{@reflection.primary_key_name}: #{@model.id}\n"
      yaml += "  #{@reflection.association_foreign_key}: #{association.id}\n\n"
      return yaml
    end
  
    def name
      return "#{join_table}_#{model.id}_#{association.id}"
    end
  
    def <=>(other)
      raise "type mismatch!" if (!@model.kind_of?(other.model.class) ||
          (!association.kind_of?(other.association.class)))
  
      model_cmp = @model.id <=> other.model.id
      association_cmp = association.id <=> other.association.id
  
      return model_cmp != 0 ? model_cmp : association_cmp
    end
  
    def eql?(other)
      return @model.eql?(other.model) && association.eql?(other.association)
    end
  
    def hash
      return (@model.id.to_s + association.id.to_s).hash
    end
  end
end
