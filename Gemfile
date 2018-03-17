source 'https://rubygems.org'
gemspec

group :development do
  gem 'test-unit'
  gem 'rake'
  gem 'redgreen', '~> 1.2'
  gem 'shoulda', '~> 3.5'
  gem 'cucumber', '1.3.11'
  gem 'redcarpet'
  gem 'unicode_utils' if RUBY_VERSION < '2.4'
end

group :extra do
    gem 'listen', '~>3.0.0'
end

group :coverage do
  gem 'simplecov', '~>0.14', :require => false
  gem 'coveralls', :require => false
end

group :debug do
  gem 'byebug', '~>3.5', :require => false, :platform => :mri
end
