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
        @site = context.registers[:site]
        config.merge!(site.config['scholar'] || {})

        references = entries.map do |e|
          reference = CiteProc.process e.to_citeproc, :style => config['style'],
            :locale => config['locale'], :format => 'html'
                    
          reference = "<span id='#{e.key}'>#{reference}</span>"
          
          if generate_details?
            reference << "<a href='#{details_link_for(e)}'>#{config['details_link']}</a>"            
          end
                    
          "<li>#{reference}</li>"
        end

        "<ol>\n#{references.join("\n")}\n</ol>"
      end
      
    end
    
  end
end

Liquid::Template.register_tag('bibliography', Jekyll::Scholar::BibliographyTag)