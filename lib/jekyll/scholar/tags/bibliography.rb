module Jekyll
  class Scholar

    class BibliographyTag < Liquid::Tag
      include Scholar::Utilities
  
      def initialize(tag_name, arguments, tokens)
        super

        @config = Scholar.defaults.dup
        @bibtex_file = arguments.strip
      end

      def render(context)
        set_context_to context

        references = entries.map do |entry|
          reference = CiteProc.process entry.to_citeproc, :style => config['style'],
            :locale => config['locale'], :format => 'html'
        
          reference = content_tag :span, reference, :id => entry.key
        
          if generate_details?
            reference << link_to(details_link_for(entry),
              config['details_link'], :class => config['details_link_class'])
          end
        
          content_tag :li, reference
        end

        content_tag :ol, references.join("\n"), :class => config['bibliography_class']
      end      
    end
    
    private
    
    def citeproc
      @citeproc ||= CiteProc::Processor.new do |p|
        p.style = config['style']
        p.format = 'html'
        p.locale = config['locale']
      end
    end
  end
end

Liquid::Template.register_tag('bibliography', Jekyll::Scholar::BibliographyTag)