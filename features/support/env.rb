require 'rr'
require 'test/unit'

require 'jekyll/scholar'

require 'debugger'


World do
  include Test::Unit::Assertions
end

TEST_DIR = File.join('/', 'tmp', 'jekyll')

def run_jekyll(options = {})
  
  options['source'] ||= TEST_DIR
  options['destination'] ||= File.join(TEST_DIR, '_site')
  
  options = Jekyll.configuration(options)

  site = Jekyll::Site.new(options)
  site.process

end
