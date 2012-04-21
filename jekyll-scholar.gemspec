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

  s.add_runtime_dependency('jekyll', '~> 0.10')
  s.add_runtime_dependency('citeproc-ruby', '~> 0.0.6')
  s.add_runtime_dependency('bibtex-ruby', '~> 2.0.5')
  
  s.add_development_dependency('bundler', '~> 1.1')
  s.add_development_dependency('rdoc', '~> 3.12')
  s.add_development_dependency('rake', '~> 0.9')
  s.add_development_dependency('redgreen', ">= 1.2.2")
  s.add_development_dependency('shoulda', ">= 2.11.3")
  s.add_development_dependency('rr', ">= 1.0.2")
  s.add_development_dependency('cucumber', ">= 0.10.0")
  s.add_development_dependency('RedCloth', ">= 4.2.1")
  s.add_development_dependency('rdiscount', ">= 1.6.5")

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables  = []
  s.require_path = 'lib'
  
end

# vim: syntax=ruby