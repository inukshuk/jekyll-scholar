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
require 'tmpdir'

TEST_DIR = File.join(Dir.tmpdir, 'jekyll')

def run_jekyll(options = {})
  original_options = Jekyll.configuration()
  options['source'] ||= TEST_DIR
  if original_options.key?('source')
      orig_path = Pathname(original_options['source'])
      # skip prepending the TEST_DIR environment when the path from the configuration file is absolute
      # note: the file path is also absolute when the source has been set previously
      if not orig_path.absolute? 
          options['source'] = File.join TEST_DIR, original_options['source']
      end
  end
  options['destination'] ||= File.join(TEST_DIR, '_site')

  options = Jekyll.configuration(options)

  site = Jekyll::Site.new(options)
  site.process

end
