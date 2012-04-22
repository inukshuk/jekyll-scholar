module Jekyll
  class Scholar
    class BibTeXConverter < Converter
      safe true
    
      priority :highest
    
      @pattern = (/bib(tex)?$/i).freeze
      @extension = '.html'.freeze
      
			class << self
				attr_reader :pattern, :extension
			end
			
      def initialize (config = {})
        super
        @config['scholar'] = Scholar.defaults.merge(@config['scholar'] || {})
        @markdown = MarkdownConverter.new config
      end
    
      def matches(extension)
				extension =~ BibTeXConverter.pattern
			end
    
      def output_ext(extension)
				BibTeXConverter.extension
			end
    
      def convert (content)
        content = BibTeX.parse(content, :include => [:meta_content], :filter => [:latex]).map do |b|
          if b.respond_to?(:to_citeproc)
            CiteProc.process b.to_citeproc, :style => @config['citation_style'],
              :locale => @config['citation_locale'], :format => 'html'
          else
              b.is_a?(BibTeX::MetaContent) ? b.to_s : ''
          end
        end
        @markdown.convert(content.join("\n"))
      end
    
    end
  end
end