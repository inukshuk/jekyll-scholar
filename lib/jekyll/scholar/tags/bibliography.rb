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

        items = entries

        if cited_only?
          items = if skip_sort?
            cited_references.uniq.map do |key|
              items.detect { |e| e.key == key }
            end
          else
            entries.select do |e|
              cited_references.include? e.key
            end
          end
        end

        items = items.take(max.to_i) if limit_entries?

        bibliography = items.each_with_index.map { |entry, index|
          reference = bibliography_tag(entry, index + 1)

          if generate_details?
            reference << link_to(details_link_for(entry),
              config['details_link'], :class => config['details_link_class'])
          end

          content_tag config['bibliography_item_tag'], reference
        }.join("\n")

        content_tag config['bibliography_list_tag'], bibliography, :class => config['bibliography_class']
        
      end
    end

  end
end

Liquid::Template.register_tag('bibliography', Jekyll::Scholar::BibliographyTag)
