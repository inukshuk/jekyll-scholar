source 'https://rubygems.org'
gemspec

group :development do
  if RUBY_VERSION >= '2.2.2'
    gem 'test-unit'
  else
    gem 'minitest', '< 5.0'
  end

  gem 'rake'
  gem 'redgreen', '~> 1.2'
  gem 'shoulda', '~> 3.5'
  gem 'cucumber', '1.3.11'
  gem 'redcarpet'

  gem 'unicode_utils'
end

group :extra do
    gem 'listen', '~>3.0.0'
end

group :coverage do
  gem 'simplecov', '~>0.14', :require => false
  gem 'rubinius-coverage', :platform => :rbx
  gem 'coveralls', :require => false
end

group :debug do
  if RUBY_VERSION > '2.0'
    gem 'byebug', '~>3.5', :require => false, :platform => :mri
  else
    gem 'debugger', '~>1.6', :require => false, :platform => [:mri_19, :mri_20]
  end

  gem 'rubinius-compiler', '~>2.0', :require => false, :platform => :rbx
  gem 'rubinius-debugger', '~>2.0', :require => false, :platform => :rbx
end
