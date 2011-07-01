require 'bibtex'
require 'citeproc'

module Jekyll
  module Scholar
    class BibTeXConverter < Converter
      safe true
    
      priority :highest
    
      DEFAULTS = Hash[*%w{
        citation_style  apa
        citation_locale en
      }].freeze
      
      PATTERN = (/^\.bib(tex)?$/i).freeze
      EXTENSION = '.html'.freeze
      
      def initialize (config = {})
        super
        @config['scholar'] = DEFAULTS.merge(@config['scholar'] || {})
        @citeproc = CiteProc::Processor.new :style => @config['citation_style'],
          :locale => @config['citation_locale'], :format => 'html'
        @markdown = MarkdownConverter.new config
      end
    
      def matches (extension); extension =~ PATTERN; end
    
      def output_ext (extension); EXTENSION; end
    
      def convert(content)
        content = BibTeX.parse(content, :include => [:meta_content]).map do |b|
          if b.respond_to? :to_citeproc
            @citeproc.bibliography(b.to_citeproc).data.join
          else
            b.is_a? BibTeX::MetaContent ? b.to_s : ''
          end
        end
        @markdown.convert(content.join("\n"))
      end
    
    end
  end
end