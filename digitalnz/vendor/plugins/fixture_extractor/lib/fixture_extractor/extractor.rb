require 'set'

module FixtureExtractor
  class Extractor
    def initialize
      @fixtures = Set.new
      @tables = Array.new
    end
  
    def add_object(object, *name)
      raise "Invalid object #{name} (nil)" if (object.nil?)
  
      if (object.is_a?(Array))
        object.each { |o| @fixtures << Fixture.new_instance(o) }
      else
        @fixtures << Fixture.new_instance(object)
      end
    end
  
    def add_table(table_name)
      @tables << table_name.to_sym
    end
  
    def dump(fixtures_dir)
      @tables.each do |table_name|
        Fixture.collect_table(table_name)
      end
  
      @fixtures.each do |fixture|
        fixture.collect_fixture
      end
  
      Fixture.fixtures.each_pair do |table, fixtures|
        write(table, fixtures_dir) do
          fixtures.each do |fixture|
            puts fixture.to_yaml
          end
        end
      end
    end
  
    private
      def write(table, fixtures_dir)
        File.open("#{fixtures_dir}/#{table}.yml", "w") do |io|
          old_stdout = $stdout
          $stdout = io
          yield
          $stdout = old_stdout
        end
      end
  end
end
