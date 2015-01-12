source 'https://rubygems.org'
gemspec

group :development do

  if RUBY_VERSION.start_with?('2.2')
    gem 'test-unit'
  else
    gem 'minitest', '< 5.0'
  end

  gem 'rake'
  gem 'redgreen', '~> 1.2'
  gem 'shoulda', '~> 3.5'
  gem 'rr', '~> 1.1'
  gem 'cucumber', '1.3.11'
  gem 'redcarpet'
  gem 'launchy', '~> 2.3'

  gem 'unicode_utils'

  gem 'simplecov', '~>0.9', :require => false
  gem 'rubinius-coverage', :platform => :rbx
  gem 'coveralls', :require => false
end

group :debug do
  gem 'debugger', '~>1.6', :require => false, :platform => [:mri_19, :mri_20]
  gem 'rubinius-compiler', '~>2.0', :require => false, :platform => :rbx
  gem 'rubinius-debugger', '~>2.0', :require => false, :platform => :rbx
end
