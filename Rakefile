require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sozdat"
    gem.summary = %Q{Rails IDE}
    gem.description = %Q{Rails IDE from Tokak Studio}
    gem.email = 'rotuka@tokak.ru'
    gem.homepage = 'http://github.com/krasivotokak/sozdat'
    gem.authors = ['Alexander Semyonov']
    gem.add_development_dependency 'shoulda', '>= 0'
    gem.add_development_dependency 'yard', '>= 0'
    gem.add_dependency 'activesupport', '2.3.4'
    gem.add_dependency 'activerecord', '2.3.4'
    gem.add_dependency 'ZenTest', '4.1.4'
    gem.add_dependency 'autotest-rails', '4.1.0'
    gem.add_dependency 'rgtk', '0.0.3'
    gem.bindir = 'bin'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end


task :environment do
  require "#{File.dirname(__FILE__)}/config/environment"
end

desc "Migrate DB"
task :migrate => :environment do
  App.connect_db
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
end

desc "Bump gem version, release and install"
task :push => %w(version:bump:patch release gemcutter:release install)
