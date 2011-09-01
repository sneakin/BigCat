begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "BigCat"
    gem.summary = %Q{RAWR!!}
    gem.description = %Q{I cat BIG.}
    gem.email = "sneakin+bigcat@semanticgap.com"
    gem.homepage = "http://github.com/sneakin/BigCat"
    gem.authors = ["Nolan Eakins"]
    gem.add_development_dependency "rspec"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end
