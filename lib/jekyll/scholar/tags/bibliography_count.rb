module Jekyll
  class Scholar

    class BibliographyCountTag < Liquid::Tag
      include Scholar::Utilities

      def initialize(tag_name, arguments, tokens)
        super

        @config = Scholar.defaults.dup

        optparse(arguments)
      end

      def render(context)
        set_context_to context

        # Add bibtex files to dependency tree
        if context.registers[:page] and context.registers[:page].key? "path"
          bibtex_paths.each do |bibtex_path|
            site.regenerator.add_dependency(
              site.in_source_dir(context.registers[:page]["path"]),
              bibtex_path
            )
          end
        end

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

          # See #90
          cited_keys.clear
        end

       entries.size
      end

    end

  end
end

Liquid::Template.register_tag('bibliography_count', Jekyll::Scholar::BibliographyCountTag)
