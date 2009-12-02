namespace :db do

  namespace :fixtures do
    desc "Extract fixtures from the current environment into the fixtures directory"
    task :extract, :fixtures_dir, :needs => :environment do |t, args|

      if (args.fixtures_dir.nil?)
        abort "please specify a directory to extract the fixtures into"
      elsif (!File.directory?(args.fixtures_dir))
        abort "could not extract fixtures: #{args.fixtures_dir} is not a directory"
      end

      require File.join(RAILS_ROOT, "test", "fixtures.rb")

      puts "extracting fixtures to #{args.fixtures_dir}"
      extractor = FixtureExtractor::Extractor.new
      FixtureHelper::FixtureMappings.instance.mappings.each do |model_class, mappings|
        mappings.values.uniq.each do |model|
          extractor.add_object(model)
        end
      end

      extractor.dump(args.fixtures_dir)
    end
  end
end