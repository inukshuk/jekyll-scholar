begin
  require 'simplecov'
  require 'coveralls' if ENV['CI']
rescue LoadError
  # ignore
end

begin
  if RUBY_VERSION > '2.0'
    require 'byebug'
  else
    require 'debugger'
  end
rescue LoadError
  # ignore
end

require 'test/unit'

require 'jekyll/scholar'

TEST_DIR = File.join('/', 'tmp', 'jekyll')

def run_jekyll(options = {})

  options['source'] ||= TEST_DIR
  options['destination'] ||= File.join(TEST_DIR, '_site')

  options = Jekyll.configuration(options)

  site = Jekyll::Site.new(options)
  site.process

end
