begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "bigcat"
    gem.summary = %Q{RAWR!!}
    gem.description = %Q{I cat BIG.}
    gem.email = "sneakin+bigcat@semanticgap.com"
    gem.homepage = "http://github.com/sneakin/BigCat"
    gem.authors = ["Nolan Eakins"]
    gem.add_development_dependency "rspec"
    gem.executables = [ 'bigcat' ]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = [ '--format', 'html', '-o', 'spec.html', '-f', 'progress' ]
end

namespace :spec do
  RSpec::Core::RakeTask.new(:coverage) do |spec|
    spec.pattern = 'spec/**/*_spec.rb'
    spec.rspec_opts = [ '--format', 'html', '-o', 'spec.html', '-f', 'progress' ]
    spec.rcov = true
    spec.rcov_opts = [ '-e', "\\.gems,_spec\\.rb"]
  end
end
