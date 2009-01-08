require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rcov/rcovtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "has_components"
    s.summary = "TODO"
    s.email = "pat.maddox@gmail.com"
    s.homepage = "http://github.com/pat-maddox/has_components"
    s.description = "TODO"
    s.authors = ["Pat Maddox"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end


begin
  require 'spec'
  require 'spec/rake/spectask'
rescue LoadError
  puts <<-EOS
To use rspec for testing you must install rspec gem:
    gem install rspec
EOS
  exit(0)
end

desc "Run the specs under spec"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/*_spec.rb']
end

"Run all specs with rcov and store coverage report in coverage"
Spec::Rake::SpecTask.new(:spec_rcov) do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.rcov = true
  t.rcov_dir = 'coverage'
  t.rcov_opts = ['--exclude', 'spec,\.autotest,/Library/Ruby/']
end


Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'has_components'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => :spec_rcov
