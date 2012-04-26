
require 'jekyll'

require 'bibtex'
require 'citeproc'

require 'jekyll/scholar/version'
require 'jekyll/scholar/converters/bibtex'
require 'jekyll/scholar/tags/bibliography'
require 'jekyll/scholar/tags/cite'
require 'jekyll/scholar/generators/details'

module Jekyll
  class Scholar
    
    @defaults = Hash[*%w{
	
      style        apa
      locale       en

      sort_by      none
      order        ascending

      source       ./_bibliography
      bibliography references.bib

      details_dir    ./bibliography
      detauls_layout bibtex.html

    }].freeze
    
    class << self
      attr_reader :defaults
    end
    
  end
end
