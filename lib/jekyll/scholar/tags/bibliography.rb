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
          references = cited_references.uniq.map do |key|
            references.detect { |e| e.key == key }
          end
        end

        bibliography = references.each_with_index.map { |entry, index|
          reference = bibliography_tag(entry, index + 1)

          if generate_details?
            reference << link_to(details_link_for(entry),
              config['details_link'], :class => config['details_link_class'])
          end

          content_tag :li, reference
        }.join("\n")

        content_tag :ol, bibliography, :class => config['bibliography_class']
      end
    end

  end
end

Liquid::Template.register_tag('bibliography', Jekyll::Scholar::BibliographyTag)
