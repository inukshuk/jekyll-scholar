
require 'jekyll'

require 'bibtex'
require 'citeproc'

require 'jekyll/scholar/version'
require 'jekyll/scholar/converters/bibtex'
require 'jekyll/scholar/tags/bibliography'
require 'jekyll/scholar/tags/cite'

module Jekyll
  class Scholar
    
    @defaults = Hash[*%w{
      style        apa
      locale       en
      sort_by      none
      order        ascending
      source       ./_bibliography
      bibliography references.bib
    }].freeze
    
    class << self
      attr_reader :defaults
    end
    
  end
end
