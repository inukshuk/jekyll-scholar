require 'jekyll'

require 'bibtex'
require 'citeproc'

require 'jekyll/scholar/version'
require 'jekyll/scholar/defaults'
require 'jekyll/scholar/utilities'

require 'jekyll/scholar/converters/bibtex'
require 'jekyll/scholar/tags/bibliography'
require 'jekyll/scholar/tags/cite'
require 'jekyll/scholar/tags/quote'
require 'jekyll/scholar/generators/details'
require 'jekyll/scholar'
module Jekyll
  class Scholar

    class BibliographyKeywordTag < Liquid::Tag
      include Scholar::Utilities
  
      def initialize(tag_name, arguments, tokens)
        super

        @config = Scholar.defaults.dup
        @keyword = arguments.strip
      end

      def render(context)
        set_context_to context

        references = entries.select{|entry| 
          if entry.respond_to?('keywords')
            entry.keywords.split(',').include?(@keyword)
          end
         }.map do |entry|
          reference = CiteProc.process entry.to_citeproc, :style => 'ieee',
            :locale => config['locale'], :format => 'html'

          reference = content_tag :span, reference, :id => entry.key

          if generate_details?
            reference << link_to(details_link_for(entry), config['details_link'])
          end

          content_tag :li, reference
        end

        content_tag :ol, references.join("\n")
      end
      
    end
    
  end
end

Liquid::Template.register_tag('bibliographyKeyword', Jekyll::Scholar::BibliographyKeywordTag)
