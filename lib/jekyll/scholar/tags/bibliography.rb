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
            reference << link_to(details_link_for(entry), config['details_link'])
          end

          content_tag :li, reference
        end

        content_tag :ol, references.join("\n")
      rescue => e
        debugger
        warn e.message
      end
      
    end
    
  end
end

Liquid::Template.register_tag('bibliography', Jekyll::Scholar::BibliographyTag)