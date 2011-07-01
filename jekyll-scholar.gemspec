# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'jekyll/scholar/version'

Gem::Specification.new do |s|
  s.name        = 'jekyll-scholar'
  s.version     = Jekyll::Scholar::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Sylvester Keil']
  s.email       = 'http://sylvester.keil.or.at'
  s.homepage    = 'http://github.com/inukshuk/jekyll-scholar'
  s.summary     = 'Jekyll extensions for the academic blogger.'
  s.description = 'A set of jekyll extensions for academic blogging.'
  s.date        = Time.now

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project = s.name

  s.add_dependency('jekyll', '~> 0.10')
  
  s.add_development_dependency('bundler', '~> 1.0')
  s.add_development_dependency('rdoc', '~> 2.5')
  s.add_development_dependency('rake', '>= 0.8')
  s.add_development_dependency('rspec', '~> 2.5')
  s.add_development_dependency('cucumber', '~> 0.3')


  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables  = []
  s.require_path = 'lib'

  s.has_rdoc     = false
  
end

# vim: syntax=ruby