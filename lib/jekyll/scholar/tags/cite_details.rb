module Jekyll
  class Scholar

    class CiteDetailsTag < Liquid::Tag
      include Scholar::Utilities

      def initialize(tag_name, arguments, tokens)
        super

        @config = Scholar.defaults.dup
        @key, arguments = arguments.strip.split(/\s+/, 2)

        optparse(arguments)
      end

      def render(context)
        set_context_to context
        cite_details key, text
      end
    end

  end
end

Liquid::Template.register_tag('cite_details', Jekyll::Scholar::CiteDetailsTag)
