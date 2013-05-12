require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jekyll/scholar/version'

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

task :default => [:features]

task :release do |t|
  system "gem build jekyll-scholar.gemspec"
  system "git tag v#{Jekyll::Scholar::VERSION}"
  system "git push --tags"
  system "gem push jekyll-scholar-#{Jekyll::Scholar::VERSION}.gem"
end
