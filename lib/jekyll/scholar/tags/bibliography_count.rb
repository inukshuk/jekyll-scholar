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

        # Add bibtex files to dependency tree.
        build_dependency_tree

        # Select cited items.
        items = adjust_cited_items

        # Return number of items.
        items.size
      end

    end

  end
end

Liquid::Template.register_tag('bibliography_count', Jekyll::Scholar::BibliographyCountTag)
