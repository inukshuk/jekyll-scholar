module Jekyll
  class Scholar

    class BibliographyTag < Liquid::Tag
      include Scholar::Utilities

      def initialize(tag_name, arguments, tokens)
        super

        @config = Scholar.defaults.dup

        optparse(arguments)
      end

      def render(context)
        set_context_to context

        references = entries

        if cited_only?
          references = cited_references.map do |key|
            references.detect { |e| e.key == key }
          end          
        end

        references.map! do |entry|
          reference = reference_tag entry

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